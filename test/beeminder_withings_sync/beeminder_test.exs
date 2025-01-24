defmodule BeeminderWithingsSync.BeeminderTest do
  use BeeminderWithingsSync.DataCase

  import BeeminderWithingsSync.AccountsFixtures

  alias BeeminderWithingsSync.Accounts.User
  alias BeeminderWithingsSync.Beeminder

  describe "beeminder_user_infos" do
    alias BeeminderWithingsSync.Beeminder.BeeminderUserInfo

    import BeeminderWithingsSync.BeeminderFixtures

    @invalid_attrs %{username: nil, access_token: nil}

    test "list_beeminder_user_infos/0 returns all beeminder_user_infos" do
      beeminder_user_info = beeminder_user_info_fixture()
      assert Beeminder.list_beeminder_user_infos() == [beeminder_user_info]
    end

    test "get_beeminder_user_info!/1 returns the beeminder_user_info with given username" do
      beeminder_user_info = beeminder_user_info_fixture()

      assert Beeminder.get_beeminder_user_info!(beeminder_user_info.username) ==
               beeminder_user_info
    end

    test "create_beeminder_user_info/1 with valid data creates a beeminder_user_info" do
      user = user_fixture()

      valid_attrs = %{
        username: "some username",
        access_token: "some access_token",
        user_id: user.id
      }

      assert {:ok, %BeeminderUserInfo{} = beeminder_user_info} =
               Beeminder.create_beeminder_user_info(valid_attrs)

      assert beeminder_user_info.username == "some username"
      assert beeminder_user_info.access_token == "some access_token"
    end

    test "create_beeminder_user_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Beeminder.create_beeminder_user_info(@invalid_attrs)
    end

    test "update_beeminder_user_info/2 with valid data updates the beeminder_user_info" do
      beeminder_user_info = beeminder_user_info_fixture()

      update_attrs = %{
        username: "some updated username",
        access_token: "some updated access_token"
      }

      assert {:ok, %BeeminderUserInfo{} = beeminder_user_info} =
               Beeminder.update_beeminder_user_info(beeminder_user_info, update_attrs)

      assert beeminder_user_info.username == "some updated username"
      assert beeminder_user_info.access_token == "some updated access_token"
    end

    test "update_beeminder_user_info/2 with invalid data returns error changeset" do
      beeminder_user_info = beeminder_user_info_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Beeminder.update_beeminder_user_info(beeminder_user_info, @invalid_attrs)

      assert beeminder_user_info ==
               Beeminder.get_beeminder_user_info!(beeminder_user_info.username)
    end

    test "insert_or_update_beeminder_user_info/3 returns the beeminder_user_info if it exists" do
      beeminder_user_info = beeminder_user_info_fixture()

      assert {:ok, ^beeminder_user_info} =
               Beeminder.insert_or_update_beeminder_user_info(
                 beeminder_user_info.username,
                 beeminder_user_info.access_token
               )
    end

    test "insert_or_update_beeminder_user_info/3 returns the beeminder_user_info if it exists and updates its access token" do
      beeminder_user_info = beeminder_user_info_fixture()
      username = beeminder_user_info.username
      access_token = "new_access_token"

      assert {:ok, %BeeminderUserInfo{username: ^username, access_token: ^access_token}} =
               Beeminder.insert_or_update_beeminder_user_info(
                 beeminder_user_info.username,
                 access_token
               )
    end

    test "insert_or_update_beeminder_user_info/3 creates a new beeminder_user_info if it does not exist" do
      username = "newuser"
      access_token = "new_access_token"

      assert {:ok, %BeeminderUserInfo{username: ^username, access_token: ^access_token}} =
               Beeminder.insert_or_update_beeminder_user_info(username, access_token)
    end

    test "insert_or_update_beeminder_user_info/3 accepts preloads option" do
      username = "newuser"
      access_token = "new_access_token"

      assert {:ok,
              %BeeminderUserInfo{username: ^username, access_token: ^access_token, user: %User{}}} =
               Beeminder.insert_or_update_beeminder_user_info(username, access_token,
                 preloads: :user
               )
    end

    test "insert_or_update_beeminder_user_info/3 accepts nested preloads option" do
      username = "newuser"
      access_token = "new_access_token"

      assert {:ok,
              %BeeminderUserInfo{
                username: ^username,
                access_token: ^access_token,
                user: %User{
                  beeminder_user_info: %BeeminderUserInfo{
                    username: ^username,
                    access_token: ^access_token
                  }
                }
              }} =
               Beeminder.insert_or_update_beeminder_user_info(username, access_token,
                 preloads: [user: :beeminder_user_info]
               )
    end

    test "delete_beeminder_user_info/1 deletes the beeminder_user_info" do
      beeminder_user_info = beeminder_user_info_fixture()

      assert {:ok, %BeeminderUserInfo{}} =
               Beeminder.delete_beeminder_user_info(beeminder_user_info)

      assert_raise Ecto.NoResultsError, fn ->
        Beeminder.get_beeminder_user_info!(beeminder_user_info.username)
      end
    end

    test "change_beeminder_user_info/1 returns a beeminder_user_info changeset" do
      beeminder_user_info = beeminder_user_info_fixture()
      assert %Ecto.Changeset{} = Beeminder.change_beeminder_user_info(beeminder_user_info)
    end
  end
end
