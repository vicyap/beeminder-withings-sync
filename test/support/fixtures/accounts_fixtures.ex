defmodule BeeminderWithingsSync.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BeeminderWithingsSync.Accounts` context.
  """

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{})
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> BeeminderWithingsSync.Accounts.create_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
