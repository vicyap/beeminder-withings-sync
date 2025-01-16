defmodule BeeminderWithingsSync.AccountsTest do
  use BeeminderWithingsSync.DataCase

  alias BeeminderWithingsSync.Accounts

  import BeeminderWithingsSync.AccountsFixtures
  alias BeeminderWithingsSync.Accounts.{User, UserToken}

  describe "get_user_by_beeminder_username/1" do
    test "does not return the user if the beeminder username does not exist" do
      refute Accounts.get_user_by_beeminder_username("unknown")
    end

    test "returns the user if the beeminder username exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user_by_beeminder_username(user.beeminder_username)
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!("11111111-1111-1111-1111-111111111111")
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "create_user/1" do
    test "requires beeminder username to be set" do
      {:error, changeset} = Accounts.create_user(%{})

      assert %{
              beeminder_username: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates beeminder username uniqueness" do
      %{beeminder_username: beeminder_username} = user_fixture()
      {:error, changeset} = Accounts.create_user(%{beeminder_username: beeminder_username})
      assert "has already been taken" in errors_on(changeset).beeminder_username
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_user_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_user_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end
end
