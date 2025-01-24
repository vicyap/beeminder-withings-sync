defmodule BeeminderWithingsSync.WithingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BeeminderWithingsSync.Withings` context.
  """

  import BeeminderWithingsSync.AccountsFixtures

  def unique_withings_user_id, do: "withings-user#{System.unique_integer()}"

  @doc """
  Generate a withings_user_info.
  """
  def withings_user_info_fixture(attrs \\ %{}) do
    user = user_fixture()

    expires_at = attrs[:expires_at] || DateTime.utc_now() |> DateTime.add(3600, :second)

    {:ok, withings_user_info} =
      attrs
      |> Enum.into(%{
        access_token: "some_access_token",
        csrf_token: "some_csrf_token",
        expires_at: expires_at,
        refresh_token: "some_refresh_token",
        scope: "user.info,user.metrics",
        token_type: "Bearer",
        withings_user_id: unique_withings_user_id(),
        user_id: user.id
      })
      |> BeeminderWithingsSync.Withings.create_withings_user_info()

    withings_user_info
  end
end
