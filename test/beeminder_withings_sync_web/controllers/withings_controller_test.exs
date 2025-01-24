defmodule BeeminderWithingsSyncWeb.WithingsControllerTest do
  use BeeminderWithingsSyncWeb.ConnCase, async: true

  import BeeminderWithingsSync.AccountsFixtures
  import BeeminderWithingsSync.WithingsFixtures
  import Mox

  alias BeeminderWithingsSync.Withings
  alias BeeminderWithingsSync.Withings.WithingsClientMock

  describe "GET /withings/auth_callback" do
    setup %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      auth_callback_url =
        ~p"/withings/auth_callback"
        |> URI.parse()
        |> Map.put(:query, URI.encode_query(%{code: "code", state: "random_state"}))
        |> URI.to_string()

      request_token_resp = %{
        "access_token" => "test_access_token",
        "refresh_token" => "test_refresh_token",
        "expires_in" => 3600,
        "scope" => "user.info,user.metrics",
        "token_type" => "Bearer",
        "userid" => "123456789"
      }

      WithingsClientMock
      |> stub(:oauth2_request_token, fn _code, _grant_type, _redirect_uri ->
        {:ok, request_token_resp}
      end)

      %{
        conn: conn,
        user: user,
        now: DateTime.utc_now(),
        auth_callback_url: auth_callback_url,
        request_token_resp: request_token_resp
      }
    end

    test "creates a new withings user info if it does not exist", %{
      conn: conn,
      auth_callback_url: auth_callback_url,
      request_token_resp: request_token_resp
    } do
      withings_user_id = request_token_resp["userid"]
      refute Withings.get_withings_user_info(withings_user_id)

      get(conn, auth_callback_url)

      withings_user_info = Withings.get_withings_user_info(withings_user_id)
      assert withings_user_info != nil
      assert withings_user_info.withings_user_id == withings_user_id
    end

    test "gets an existing withings user info by user id and overwrites attrs", %{
      conn: conn,
      user: user,
      now: now,
      auth_callback_url: auth_callback_url,
      request_token_resp: request_token_resp
    } do
      withings_user_id = request_token_resp["userid"]

      withings_user_info_fixture(
        withings_user_id: withings_user_id,
        user_id: user.id
      )

      get(conn, auth_callback_url)

      withings_user_info = Withings.get_withings_user_info(withings_user_id)
      assert withings_user_info != nil
      assert withings_user_info.withings_user_id == withings_user_id
      assert withings_user_info.user_id == user.id
      assert withings_user_info.access_token == request_token_resp["access_token"]
      assert withings_user_info.refresh_token == request_token_resp["refresh_token"]

      assert withings_user_info.expires_at ==
               now
               |> DateTime.add(request_token_resp["expires_in"], :second)
               |> DateTime.truncate(:second)

      assert withings_user_info.scope == request_token_resp["scope"]
      assert withings_user_info.token_type == request_token_resp["token_type"]
    end
  end
end
