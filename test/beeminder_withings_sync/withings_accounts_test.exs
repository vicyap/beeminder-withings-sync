defmodule BeeminderWithingsSync.WithingsAccountsTest do
  use BeeminderWithingsSync.DataCase

  alias BeeminderWithingsSync.WithingsAccounts

  describe "withings_access_tokens" do
    alias BeeminderWithingsSync.WithingsAccounts.WithingsAccessToken

    import BeeminderWithingsSync.WithingsAccountsFixtures

    @invalid_attrs %{scope: nil, access_token: nil, refresh_token: nil, expires_in: nil, token_type: nil, withings_user_id: nil}

    test "list_withings_access_tokens/0 returns all withings_access_tokens" do
      withings_access_token = withings_access_token_fixture()
      assert WithingsAccounts.list_withings_access_tokens() == [withings_access_token]
    end

    test "get_withings_access_token!/1 returns the withings_access_token with given id" do
      withings_access_token = withings_access_token_fixture()
      assert WithingsAccounts.get_withings_access_token!(withings_access_token.id) == withings_access_token
    end

    test "create_withings_access_token/1 with valid data creates a withings_access_token" do
      valid_attrs = %{scope: "some scope", access_token: "some access_token", refresh_token: "some refresh_token", expires_in: 42, token_type: "some token_type", withings_user_id: "some withings_user_id"}

      assert {:ok, %WithingsAccessToken{} = withings_access_token} = WithingsAccounts.create_withings_access_token(valid_attrs)
      assert withings_access_token.scope == "some scope"
      assert withings_access_token.access_token == "some access_token"
      assert withings_access_token.refresh_token == "some refresh_token"
      assert withings_access_token.expires_in == 42
      assert withings_access_token.token_type == "some token_type"
      assert withings_access_token.withings_user_id == "some withings_user_id"
    end

    test "create_withings_access_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WithingsAccounts.create_withings_access_token(@invalid_attrs)
    end

    test "update_withings_access_token/2 with valid data updates the withings_access_token" do
      withings_access_token = withings_access_token_fixture()
      update_attrs = %{scope: "some updated scope", access_token: "some updated access_token", refresh_token: "some updated refresh_token", expires_in: 43, token_type: "some updated token_type", withings_user_id: "some updated withings_user_id"}

      assert {:ok, %WithingsAccessToken{} = withings_access_token} = WithingsAccounts.update_withings_access_token(withings_access_token, update_attrs)
      assert withings_access_token.scope == "some updated scope"
      assert withings_access_token.access_token == "some updated access_token"
      assert withings_access_token.refresh_token == "some updated refresh_token"
      assert withings_access_token.expires_in == 43
      assert withings_access_token.token_type == "some updated token_type"
      assert withings_access_token.withings_user_id == "some updated withings_user_id"
    end

    test "update_withings_access_token/2 with invalid data returns error changeset" do
      withings_access_token = withings_access_token_fixture()
      assert {:error, %Ecto.Changeset{}} = WithingsAccounts.update_withings_access_token(withings_access_token, @invalid_attrs)
      assert withings_access_token == WithingsAccounts.get_withings_access_token!(withings_access_token.id)
    end

    test "delete_withings_access_token/1 deletes the withings_access_token" do
      withings_access_token = withings_access_token_fixture()
      assert {:ok, %WithingsAccessToken{}} = WithingsAccounts.delete_withings_access_token(withings_access_token)
      assert_raise Ecto.NoResultsError, fn -> WithingsAccounts.get_withings_access_token!(withings_access_token.id) end
    end

    test "change_withings_access_token/1 returns a withings_access_token changeset" do
      withings_access_token = withings_access_token_fixture()
      assert %Ecto.Changeset{} = WithingsAccounts.change_withings_access_token(withings_access_token)
    end
  end
end
