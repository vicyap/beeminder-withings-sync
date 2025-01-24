defmodule BeeminderWithingsSyncWeb.PageControllerTest do
  use BeeminderWithingsSyncWeb.ConnCase

  test "GET /", %{conn: conn} do
    get(conn, ~p"/")
  end
end
