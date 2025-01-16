defmodule BeeminderWithingsSyncWeb.BeeminderController do
  use BeeminderWithingsSyncWeb, :controller

  def auth_callback(conn, _params) do
    # params: %{"access_token" => "access_token", "username" => "username"}
    redirect(conn, to: ~p"/")
  end
end
