defmodule BeeminderWithingsSyncWeb.DashboardLiveTest do
  use BeeminderWithingsSyncWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  import BeeminderWithingsSync.AccountsFixtures
  import BeeminderWithingsSync.BeeminderFixtures
  import BeeminderWithingsSync.WithingsFixtures

  alias BeeminderWithingsSync.Accounts

  setup %{conn: conn} do
    user = user_fixture()
    _beeminder_user_info = beeminder_user_info_fixture(user_id: user.id)
    _withings_user_info = withings_user_info_fixture(user_id: user.id)
    conn = log_in_user(conn, user)
    user = Accounts.get_user!(user.id, preloads: [:beeminder_user_info, :withings_user_info])
    %{conn: conn, user: user}
  end

  describe "dashboard page" do
    test "renders dashboard page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/app")

      assert html =~ "Authorize Withings"
    end
  end
end
