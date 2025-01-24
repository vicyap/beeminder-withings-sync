defmodule BeeminderWithingsSync.Withings.TokenRefresherTest do
  use BeeminderWithingsSync.DataCase, async: false

  import ExUnit.CaptureLog
  import Mox

  alias BeeminderWithingsSync.Withings
  alias BeeminderWithingsSync.Withings.TokenRefresher
  alias BeeminderWithingsSync.Withings.WithingsClientMock
  alias BeeminderWithingsSync.WithingsFixtures

  # setup :verify_on_exit!

  setup do
    request_token_resp = %{
      "access_token" => "test_access_token",
      "refresh_token" => "test_refresh_token",
      "expires_in" => 3600,
      "scope" => "user.info,user.metrics",
      "token_type" => "Bearer",
      "userid" => "123456789"
    }

    WithingsClientMock
    |> stub(:oauth2_request_token, fn _refresh_token, "refresh_token" ->
      {:ok, request_token_resp}
    end)

    # Start the TokenRefresher as a supervised process for each test
    # start_supervised!(TokenRefresher)
    {:ok, _pid} = TokenRefresher.start_link([])

    :ok
  end

  describe "on startup" do
    test "it schedules refresh for existing WithingsUserInfo records" do
      expires_at = DateTime.utc_now() |> DateTime.add(-3600, :second)
      # Insert several user infos
      info1 = WithingsFixtures.withings_user_info_fixture(expires_at: expires_at)
      # info2 = WithingsFixtures.withings_user_info_fixture()
      # info3 = WithingsFixtures.withings_user_info_fixture()

      # Capture logs to see scheduling
      log =
        capture_log(fn ->
          # We'll manually trigger the "load_and_schedule_all" message for clarity
          # But typically it's triggered automatically by `init/1`.
          send(TokenRefresher, :load_and_schedule_all)
          # Let GenServer process the message
          Process.sleep(50)
        end)

      # We expect to see logs referencing scheduling for the above user_ids
      assert log =~ "Scheduled token refresh for (withings_user_id=#{info1.withings_user_id}"
      # assert log =~ "Scheduled token refresh for (withings_user_id=#{info2.withings_user_id}"
      # assert log =~ "Scheduled token refresh for (withings_user_id=#{info3.withings_user_id}"
    end
  end

  describe "schedule_refresh/1 with expired token" do
    test "refreshes immediately and updates the refresh_token" do
      # Suppose we have a token that expired 1 minute ago
      expired_at = DateTime.add(DateTime.utc_now(), -60, :second)
      old_refresh_token = "old_refresh_token"

      user_info =
        WithingsFixtures.withings_user_info_fixture(%{
          expires_at: expired_at,
          refresh_token: old_refresh_token
        })

      # When the GenServer tries to refresh, we want to simulate a successful OAuth2 call:
      new_refresh_token = "brand_new_refresh_token"
      new_access_token = "brand_new_access_token"

      WithingsClientMock
      |> expect(:oauth2_request_token, fn ^old_refresh_token, "refresh_token" ->
        # Return a payload that includes new tokens
        {:ok,
         %{
           "access_token" => new_access_token,
           "refresh_token" => new_refresh_token,
           "expires_in" => 7200,
           "token_type" => "Bearer",
           "scope" => "user.info,user.metrics"
         }}
      end)

      # Call schedule_refresh (public API).
      # Because the token is expired, it should effectively schedule a refresh *immediately*.
      log =
        capture_log(fn ->
          TokenRefresher.schedule_refresh(user_info)
          # Let the GenServer process everything
          Process.sleep(100)
        end)

      # See if it tried to refresh
      assert log =~
               "Time to refresh Withings token for (withings_user_id=#{user_info.withings_user_id}"

      # Verify the DB is updated with new tokens
      updated_info = Withings.get_withings_user_info(user_info.withings_user_id)
      assert updated_info.refresh_token == new_refresh_token
      assert updated_info.access_token == new_access_token
      refute updated_info.refresh_token == old_refresh_token
    end
  end

  describe "post-refresh re-scheduling" do
    test "schedules a new timer with the updated expires_at" do
      # We'll set a future expires_at
      future_expires_at = DateTime.add(DateTime.utc_now(), 3600, :second)
      refresh_token = "test_refresh_token"

      user_info =
        WithingsFixtures.withings_user_info_fixture(%{
          expires_at: future_expires_at,
          refresh_token: refresh_token
        })

      WithingsClientMock
      |> stub(:oauth2_request_token, fn ^refresh_token, "refresh_token" ->
        # Suppose the new token is valid for another hour
        {:ok,
         %{
           "access_token" => "another_access",
           "refresh_token" => "another_refresh",
           "expires_in" => 3600,
           "token_type" => "Bearer",
           "scope" => "user.info,user.metrics"
         }}
      end)

      # Manually send a :refresh message to simulate time-based triggering
      log =
        capture_log(fn ->
          send(TokenRefresher, {:refresh, user_info.withings_user_id})
          Process.sleep(100)
        end)

      # We expect to see a log about "Scheduled token refresh" again
      # because we do `schedule_self(updated_withings_user_info)` after a successful refresh
      assert log =~ "Scheduled token refresh for (withings_user_id=#{user_info.withings_user_id}"

      assert log =~
               "Time to refresh Withings token for (withings_user_id=#{user_info.withings_user_id}"
    end
  end

  describe "handle refresh errors" do
    test "logs an error when refresh fails" do
      user_info = WithingsFixtures.withings_user_info_fixture()

      WithingsClientMock
      |> expect(:oauth2_request_token, fn _, _ ->
        {:error, :invalid_grant}
      end)

      log =
        capture_log(fn ->
          send(TokenRefresher, {:refresh, user_info.withings_user_id})
          Process.sleep(50)
        end)

      assert log =~
               "Failed to refresh token for withings_user_id=#{user_info.withings_user_id}: :invalid_grant"
    end

    test "logs an unexpected error if something else goes wrong" do
      user_info = WithingsFixtures.withings_user_info_fixture()

      # Let's pretend get_withings_user_info returned nil or something weird
      # We can force that by changing the DB record first or by stubbing.
      # Easiest is to stub the get_withings_user_info so it returns nil
      # But let's do something simpler: just delete the record
      :ok = Withings.delete_withings_user_info(user_info)

      log =
        capture_log(fn ->
          send(TokenRefresher, {:refresh, user_info.withings_user_id})
          Process.sleep(50)
        end)

      assert log =~
               "Unexpected error while refreshing token for withings_user_id=#{user_info.withings_user_id}"
    end
  end
end
