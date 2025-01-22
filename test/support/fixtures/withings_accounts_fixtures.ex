defmodule BeeminderWithingsSync.WithingsAccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BeeminderWithingsSync.WithingsAccounts` context.
  """

  @doc """
  Generate a withings_access_token.
  """
  def withings_access_token_fixture(attrs \\ %{}) do
    {:ok, withings_access_token} =
      attrs
      |> Enum.into(%{
        access_token: "some access_token",
        expires_in: 42,
        refresh_token: "some refresh_token",
        scope: "some scope",
        token_type: "some token_type",
        withings_user_id: "some withings_user_id"
      })
      |> BeeminderWithingsSync.WithingsAccounts.create_withings_access_token()

    withings_access_token
  end
end
