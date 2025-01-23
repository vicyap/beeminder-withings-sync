defmodule BeeminderWithingsSyncWeb.PageController do
  use BeeminderWithingsSyncWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)
    redirect(conn, to: ~p"/app")
  end
end
