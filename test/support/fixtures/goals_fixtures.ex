defmodule BeeminderWithingsSync.GoalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BeeminderWithingsSync.Goals` context.
  """

  import BeeminderWithingsSync.AccountsFixtures

  @doc """
  Generate a goal.
  """
  def goal_fixture(attrs \\ %{}) do
    user_id = Map.get(attrs, :user_id, user_fixture().id)

    {:ok, goal} =
      attrs
      |> Enum.into(%{
        user_id: user_id,
        slug: "slug"
      })
      |> BeeminderWithingsSync.Goals.create_goal()

    goal
  end
end
