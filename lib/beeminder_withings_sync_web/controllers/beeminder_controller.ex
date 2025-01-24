defmodule BeeminderWithingsSyncWeb.BeeminderController do
  use BeeminderWithingsSyncWeb, :controller

  alias BeeminderWithingsSync.Beeminder
  alias BeeminderWithingsSyncWeb.UserAuth

  def auth_callback(conn, _params = %{"access_token" => access_token, "username" => _username}) do
    beeminder_client = Application.get_env(:beeminder_withings_sync, :beeminder_client_module)

    with {:ok, %{"username" => username}} <- beeminder_client.get_me(access_token),
         {:ok, beeminder_user_info} <-
           Beeminder.insert_or_update_beeminder_user_info_by_username(username, access_token,
             preloads: :user
           ) do
      UserAuth.log_in_user(conn, beeminder_user_info.user)
    else
      {:error, _reason} ->
        # TODO: Log an error
        redirect(conn, to: ~p"/users/log_in")

      _ ->
        # TODO: catch-all log unknown error
        redirect(conn, to: ~p"/users/log_in")
    end
  end

  def auth_callback(conn, _params) do
    redirect(conn, to: ~p"/users/log_in")
  end
end
