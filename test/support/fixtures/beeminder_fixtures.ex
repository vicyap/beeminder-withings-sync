defmodule BeeminderWithingsSync.BeeminderFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BeeminderWithingsSync.Beeminder` context.
  """

  import BeeminderWithingsSync.AccountsFixtures

  def unique_beeminder_username, do: "beeminder-user-#{System.unique_integer()}"

  @doc """
  Generate a beeminder_user_info.
  """
  def beeminder_user_info_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, beeminder_user_info} =
      attrs
      |> Enum.into(%{
        access_token: "abc123",
        username: unique_beeminder_username(),
        user_id: user.id
      })
      |> BeeminderWithingsSync.Beeminder.create_beeminder_user_info()

    beeminder_user_info
  end
end
