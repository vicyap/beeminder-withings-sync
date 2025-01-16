defmodule BeeminderWithingsSyncWeb.BeeminderController do
  use BeeminderWithingsSyncWeb, :controller

  alias BeeminderWithingsSync.Accounts
  alias BeeminderWithingsSync.Beeminder
  alias BeeminderWithingsSyncWeb.UserAuth

  def auth_callback(conn, _params = %{access_token: access_token}) do
    # params: %{"access_token" => "access_token", "username" => "username"}
    case Beeminder.get_current_user(access_token) do
      {:ok, resp} ->
        beeminder_username = resp["username"]

        case Accounts.get_or_create_user_by_beeminder_username(beeminder_username) do
          {:ok, user} ->
            conn
            |> UserAuth.log_in_user(user)
            |> redirect(to: ~p"/app")

          {:error, _reason} ->
            redirect(conn, ~p"/users/log_in")
        end

      {:error, _reason} ->
        redirect(conn, ~p"/users/log_in")
    end
  end

  def auth_callback(conn, _params) do
    redirect(conn, to: ~p"/users/log_in")
  end
end
