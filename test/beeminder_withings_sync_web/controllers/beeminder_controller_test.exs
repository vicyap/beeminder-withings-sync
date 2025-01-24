defmodule BeeminderWithingsSyncWeb.BeeminderControllerTest do
  use BeeminderWithingsSyncWeb.ConnCase, async: true

  import BeeminderWithingsSync.BeeminderFixtures
  import Mox

  alias BeeminderWithingsSync.Beeminder
  alias BeeminderWithingsSync.Beeminder.BeeminderClientMock

  describe "GET /beeminder/auth_callback" do
    setup do
      access_token = "test_access_token"
      username = "testuser"
      params = %{"access_token" => access_token, "username" => username}

      auth_callback_url =
        ~p"/beeminder/auth_callback"
        |> URI.parse()
        |> Map.put(:query, URI.encode_query(params))
        |> URI.to_string()

      BeeminderClientMock
      |> stub(:get_me, fn ^access_token -> {:ok, %{"username" => username}} end)

      %{auth_callback_url: auth_callback_url, username: username, access_token: access_token}
    end

    test "creates a new beeminder user info if it does not exist", %{
      conn: conn,
      auth_callback_url: auth_callback_url,
      username: username
    } do
      refute Beeminder.get_beeminder_user_info(username)

      get(conn, auth_callback_url)

      beeminder_user_info = Beeminder.get_beeminder_user_info(username)
      assert beeminder_user_info != nil
      assert beeminder_user_info.username == username
    end

    test "gets an existing beeminder user info by beeminder username", %{
      conn: conn,
      auth_callback_url: auth_callback_url,
      username: username
    } do
      beeminder_user_info = beeminder_user_info_fixture(username: username)

      get(conn, auth_callback_url)

      assert Beeminder.get_beeminder_user_info!(username).username == beeminder_user_info.username
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
      |> stub(:get_me, fn _ -> {:error, :invalid_token} end)

      conn = get(conn, auth_callback_url)

      refute get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/users/log_in"
    end
  end
end
