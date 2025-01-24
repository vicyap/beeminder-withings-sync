defmodule BeeminderWithingsSyncWeb.WithingsController do
  use BeeminderWithingsSyncWeb, :controller

  alias BeeminderWithingsSync.Withings
  alias BeeminderWithingsSyncWeb.OAuthHelpers

  def auth_callback(conn, %{"code" => code, "state" => _state}) do
    # TODO: verify state

    withings_client = Application.get_env(:beeminder_withings_sync, :withings_client_module)

    with {:ok, attrs = %{}} <-
           withings_client.oauth2_request_token(
             code,
             "authorization_code",
             OAuthHelpers.withings_redirect_uri()
           ),
         {:ok, _} <-
           Withings.insert_or_update_withings_user_info_by_user_id(
             conn.assigns[:current_user].id,
             attrs
           ) do
      redirect(conn, to: ~p"/app")
    else
      {:error, reason} ->
        IO.puts("Error: #{reason}")
        redirect(conn, to: ~p"/app")

      _ ->
        IO.puts("Unexpected error")
        redirect(conn, to: ~p"/app")
    end
  end

  def auth_callback(conn, _params) do
    redirect(conn, to: ~p"/app")
  end
end
