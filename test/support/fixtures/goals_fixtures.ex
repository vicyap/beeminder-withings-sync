defmodule BeeminderWithingsSync.GoalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BeeminderWithingsSync.Goals` context.
  """

  @doc """
  Generate a goal.
  """
  def goal_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> Enum.into(%{
        slug: "slug"
      })
      |> BeeminderWithingsSync.Goals.create_goal()

    goal
  end
end
