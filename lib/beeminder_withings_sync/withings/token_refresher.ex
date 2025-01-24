defmodule BeeminderWithingsSync.Withings.TokenRefresher do
  @moduledoc """
  GenServer that schedules and performs Withings token refreshes just before they expire.
  """

  use GenServer
  require Logger

  alias BeeminderWithingsSync.Withings
  alias BeeminderWithingsSync.Withings.WithingsUserInfo

  # Configure your buffer here (in ms). 5 minutes = 300_000 ms
  @default_refresh_buffer_ms 300_000

  @type state :: %{
          timers: %{
            (withings_user_id :: String.t()) => reference
          },
          refresh_buffer_ms: non_neg_integer()
        }

  # Public API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Schedules a token refresh for the given WithingsUserInfo, based on `expires_at` minus the refresh buffer.
  """
  def schedule_refresh(%WithingsUserInfo{} = withings_user_info) do
    GenServer.cast(__MODULE__, {:schedule_refresh, withings_user_info})
  end

  # GenServer callbacks

  @impl true
  def init(opts) do
    refresh_buffer_ms = Keyword.get(opts, :refresh_buffer_ms, @default_refresh_buffer_ms)

    # We keep track of each withings_user_id => Process.send_after reference
    state = %{
      timers: %{},
      refresh_buffer_ms: refresh_buffer_ms
    }

    Process.send_after(self(), :load_and_schedule_all, 0)
    {:ok, state}
  end

  @impl true
  def handle_info(:load_and_schedule_all, state) do
    Withings.list_withings_user_infos()
    |> Enum.each(&schedule_self/1)

    {:noreply, state}
  end

  @impl true
  def handle_info({:refresh, withings_user_id}, state) do
    Logger.info(
      "Time to refresh Withings token for (withings_user_id=#{withings_user_id}, user_id=#{withings_user_id.user_id})"
    )

    refresh_token(withings_user_id)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:schedule_refresh, %WithingsUserInfo{} = withings_user_info}, state) do
    # This function implements the "public API" for scheduling a refresh
    # which always cancels any prior schedule for the same user_id
    state = cancel_existing_timer_if_any(state, withings_user_info.withings_user_id)
    schedule_self(withings_user_info)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:internal_schedule, %WithingsUserInfo{} = withings_user_info}, state) do
    now = DateTime.utc_now()

    # "expires_at - buffer" => the time we want the refresh to happen
    target_refresh_time =
      DateTime.add(withings_user_info.expires_at, -div(state.refresh_buffer_ms, 1000), :second)

    diff_ms = DateTime.diff(target_refresh_time, now, :millisecond)
    diff_ms = if diff_ms < 0, do: 0, else: diff_ms

    ref = Process.send_after(self(), {:refresh, withings_user_info.withings_user_id}, diff_ms)
    new_state = put_in(state, [:timers, withings_user_info.withings_user_id], ref)

    Logger.debug("""
    Scheduled token refresh for (withings_user_id=#{withings_user_info.withings_user_id}, user_id=#{withings_user_info.user_id})
    in #{diff_ms} ms (target_refresh_time=#{inspect(target_refresh_time)}, now=#{inspect(now)})
    """)

    {:noreply, new_state}
  end

  defp schedule_self(%WithingsUserInfo{} = withings_user_info) do
    GenServer.cast(__MODULE__, {:internal_schedule, withings_user_info})
  end

  defp cancel_existing_timer_if_any(state, withings_user_id) do
    case Map.pop(state.timers, withings_user_id) do
      {nil, _} ->
        state

      {ref, new_timers} ->
        Process.cancel_timer(ref)
        %{state | timers: new_timers}
    end
  end

  defp refresh_token(withings_user_id) do
    IO.inspect(withings_user_id)

    with %WithingsUserInfo{refresh_token: refresh_token} = withings_user_info <-
           Withings.get_withings_user_info(withings_user_id),
         withings_client <-
           Application.get_env(:beeminder_withings_sync, :withings_client_module),
         _ <- IO.inspect(withings_client),
         {:ok, attrs = %{}} <-
           withings_client.oauth2_request_token(refresh_token, "refresh_token"),
         {:ok, %WithingsUserInfo{} = updated_withings_user_info} <-
           Withings.update_withings_user_info(withings_user_info, attrs) do
      schedule_self(updated_withings_user_info)
    else
      {:error, reason} ->
        Logger.error(
          "Failed to refresh token for withings_user_id=#{withings_user_id}: #{inspect(reason)}"
        )

      error ->
        Logger.error(
          "Unexpected error while refreshing token for withings_user_id=#{withings_user_id}: #{inspect(error)}"
        )
    end
  end
end
