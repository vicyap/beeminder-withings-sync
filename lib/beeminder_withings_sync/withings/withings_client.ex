defmodule BeeminderWithingsSync.Withings.WithingsClient do
  @moduledoc """
  Behavior for interacting with Withings API.
  """

  # @callback oauth2_request_token(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}
  @callback oauth2_request_token(String.t(), String.t(), String.t()) ::
              {:ok, map()} | {:error, String.t()}
end
