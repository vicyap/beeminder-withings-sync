defmodule BeeminderWithingsSync.WithingsTest do
  use BeeminderWithingsSync.DataCase

  alias BeeminderWithingsSync.Withings

  describe "withings_user_infos" do
    alias BeeminderWithingsSync.Withings.WithingsUserInfo

    import BeeminderWithingsSync.WithingsFixtures

    @invalid_attrs %{scope: nil, withings_user_id: nil, access_token: nil, refresh_token: nil, expires_at: nil, token_type: nil, csrf_token: nil}

    test "list_withings_user_infos/0 returns all withings_user_infos" do
      withings_user_info = withings_user_info_fixture()
      assert Withings.list_withings_user_infos() == [withings_user_info]
    end

    test "get_withings_user_info!/1 returns the withings_user_info with given id" do
      withings_user_info = withings_user_info_fixture()
      assert Withings.get_withings_user_info!(withings_user_info.id) == withings_user_info
    end

    test "create_withings_user_info/1 with valid data creates a withings_user_info" do
      valid_attrs = %{scope: "some scope", withings_user_id: "some withings_user_id", access_token: "some access_token", refresh_token: "some refresh_token", expires_at: ~U[2025-01-22 22:33:00Z], token_type: "some token_type", csrf_token: "some csrf_token"}

      assert {:ok, %WithingsUserInfo{} = withings_user_info} = Withings.create_withings_user_info(valid_attrs)
      assert withings_user_info.scope == "some scope"
      assert withings_user_info.withings_user_id == "some withings_user_id"
      assert withings_user_info.access_token == "some access_token"
      assert withings_user_info.refresh_token == "some refresh_token"
      assert withings_user_info.expires_at == ~U[2025-01-22 22:33:00Z]
      assert withings_user_info.token_type == "some token_type"
      assert withings_user_info.csrf_token == "some csrf_token"
    end

    test "create_withings_user_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Withings.create_withings_user_info(@invalid_attrs)
    end

    test "update_withings_user_info/2 with valid data updates the withings_user_info" do
      withings_user_info = withings_user_info_fixture()
      update_attrs = %{scope: "some updated scope", withings_user_id: "some updated withings_user_id", access_token: "some updated access_token", refresh_token: "some updated refresh_token", expires_at: ~U[2025-01-23 22:33:00Z], token_type: "some updated token_type", csrf_token: "some updated csrf_token"}

      assert {:ok, %WithingsUserInfo{} = withings_user_info} = Withings.update_withings_user_info(withings_user_info, update_attrs)
      assert withings_user_info.scope == "some updated scope"
      assert withings_user_info.withings_user_id == "some updated withings_user_id"
      assert withings_user_info.access_token == "some updated access_token"
      assert withings_user_info.refresh_token == "some updated refresh_token"
      assert withings_user_info.expires_at == ~U[2025-01-23 22:33:00Z]
      assert withings_user_info.token_type == "some updated token_type"
      assert withings_user_info.csrf_token == "some updated csrf_token"
    end

    test "update_withings_user_info/2 with invalid data returns error changeset" do
      withings_user_info = withings_user_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Withings.update_withings_user_info(withings_user_info, @invalid_attrs)
      assert withings_user_info == Withings.get_withings_user_info!(withings_user_info.id)
    end

    test "delete_withings_user_info/1 deletes the withings_user_info" do
      withings_user_info = withings_user_info_fixture()
      assert {:ok, %WithingsUserInfo{}} = Withings.delete_withings_user_info(withings_user_info)
      assert_raise Ecto.NoResultsError, fn -> Withings.get_withings_user_info!(withings_user_info.id) end
    end

    test "change_withings_user_info/1 returns a withings_user_info changeset" do
      withings_user_info = withings_user_info_fixture()
      assert %Ecto.Changeset{} = Withings.change_withings_user_info(withings_user_info)
    end
  end
end
