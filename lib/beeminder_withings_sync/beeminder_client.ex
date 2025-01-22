defmodule BeeminderWithingsSync.BeeminderClient do
  @moduledoc """
  Behavior for interacting with Beeminder API.
  """

  @callback get_current_user(String.t()) :: {:ok, map()} | {:error, String.t()}
end
