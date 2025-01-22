defmodule BeeminderWithingsSync.Withings do
  def auth_url() do
    params = %{
      client_id: Application.fetch_env!(:beeminder_withings_sync, :withings_client_id),
      redirect_uri: redirect_uri(),
      response_type: "code",
      scope: "user.info,user.metrics",
      state: "random_state"
    }

    auth_base_url()
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  def redirect_uri() do
    BeeminderWithingsSyncWeb.Endpoint.url()
    |> Path.join("/withings/auth_callback")
  end

  defp auth_base_url(),
    do: Application.fetch_env!(:beeminder_withings_sync, :withings_auth_base_url)
end
