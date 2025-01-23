defmodule BeeminderWithingsSyncWeb.OAuthHelpers do
  @moduledoc """
  Helper functions for handling OAuth2 authentication.
  """

  def beeminder_redirect_uri() do
    BeeminderWithingsSyncWeb.Endpoint.url()
    |> Path.join("/beeminder/auth_callback")
  end

  def withings_redirect_uri() do
    BeeminderWithingsSyncWeb.Endpoint.url()
    |> Path.join("/withings/auth_callback")
  end
end
