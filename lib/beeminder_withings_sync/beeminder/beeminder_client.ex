defmodule BeeminderWithingsSync.Beeminder.BeeminderClient do
  @moduledoc """
  Behavior for interacting with Beeminder API.
  """

  @callback get_me(String.t()) :: {:ok, map()} | {:error, String.t()}
  @callback get_user(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}
end
