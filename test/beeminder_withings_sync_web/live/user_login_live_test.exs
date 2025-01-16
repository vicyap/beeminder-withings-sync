defmodule BeeminderWithingsSyncWeb.UserLoginLiveTest do
  use BeeminderWithingsSyncWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import BeeminderWithingsSync.AccountsFixtures

  describe "Log in page" do
    test "renders log in page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/log_in")

      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/log_in")
        |> follow_redirect(conn, "/app")

      assert {:ok, _conn} = result
    end
  end

  # describe "user login" do
  #   test "redirects if user login with valid credentials", %{conn: conn} do
  #     user = user_fixture()
  #     {:ok, lv, _html} = live(conn, ~p"/users/log_in")
  #     assert redirected_to(conn) == ~p"/"
  #   end
  #   test "redirects to login page with a flash error if there are no valid credentials", %{
  #     conn: conn
  #   } do
  #     {:ok, lv, _html} = live(conn, ~p"/users/log_in")
  #     conn = submit_form(form, conn)
  #     assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid"
  #     assert redirected_to(conn) == "/users/log_in"
  #   end
  # end
end
