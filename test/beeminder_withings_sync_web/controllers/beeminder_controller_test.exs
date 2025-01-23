defmodule BeeminderWithingsSyncWeb.BeeminderControllerTest do
  use BeeminderWithingsSyncWeb.ConnCase, async: true

  import BeeminderWithingsSync.AccountsFixtures
  import Mox

  alias BeeminderWithingsSync.Accounts
  alias BeeminderWithingsSync.Beeminder.BeeminderClientMock

  describe "GET /beeminder/auth_callback" do
    setup do
      access_token = "abc123"
      username = "testuser"
      params = %{"access_token" => access_token, "username" => username}

      auth_callback_url =
        ~p"/beeminder/auth_callback"
        |> URI.parse()
        |> Map.put(:query, URI.encode_query(params))
        |> URI.to_string()

      BeeminderClientMock
      |> stub(:get_current_user, fn ^access_token -> {:ok, %{"username" => username}} end)

      %{auth_callback_url: auth_callback_url, username: username}
    end

    test "creates a new user if a user does not exist", %{
      conn: conn,
      auth_callback_url: auth_callback_url,
      username: username
    } do
      refute Accounts.get_user_by_beeminder_username(username)

      get(conn, auth_callback_url)

      user = Accounts.get_user_by_beeminder_username(username)
      assert user != nil
      assert user.beeminder_username == username
    end

    test "gets an existing user by beeminder username", %{
      conn: conn,
      auth_callback_url: auth_callback_url,
      username: username
    } do
      user = user_fixture(beeminder_username: username)

      get(conn, auth_callback_url)

      assert Accounts.get_user_by_beeminder_username(username) == user
    end

    test "signs in the user and redirects to /app", %{
      conn: conn,
      auth_callback_url: auth_callback_url
    } do
      conn = get(conn, auth_callback_url)

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/app"
    end

    test "an invalid access token redirects to log in page", %{
      conn: conn,
      auth_callback_url: auth_callback_url
    } do
      BeeminderClientMock
      |> stub(:get_current_user, fn _ -> {:error, :invalid_token} end)

      conn = get(conn, auth_callback_url)

      refute get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end
end
