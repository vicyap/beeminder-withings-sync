defmodule BeeminderWithingsSyncWeb.BeeminderController do
  use BeeminderWithingsSyncWeb, :controller

  alias BeeminderWithingsSync.Accounts
  alias BeeminderWithingsSyncWeb.UserAuth

  def auth_callback(conn, _params = %{"access_token" => access_token, "username" => _username}) do
    beeminder_client = Application.get_env(:beeminder_withings_sync, :beeminder_client_module)

    case beeminder_client.get_current_user(access_token) do
      {:ok, resp} ->
        beeminder_username = Map.fetch!(resp, "username")

        case Accounts.get_or_create_user_by_beeminder_username(beeminder_username) do
          {:ok, user} ->
            conn
            |> UserAuth.log_in_user(user)

          {:error, _reason} ->
            redirect(conn, to: ~p"/users/log_in")
        end

      {:error, _reason} ->
        redirect(conn, to: ~p"/users/log_in")
    end
  end

  def auth_callback(conn, _params) do
    redirect(conn, to: ~p"/users/log_in")
  end
end
