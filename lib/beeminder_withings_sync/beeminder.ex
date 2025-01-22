defmodule BeeminderWithingsSync.Beeminder do
  def auth_url() do
    redirect_uri =
      BeeminderWithingsSyncWeb.Endpoint.url()
      |> Path.join("/beeminder/auth_callback")

    params = %{
      client_id: Application.fetch_env!(:beeminder_withings_sync, :beeminder_client_id),
      redirect_uri: redirect_uri,
      response_type: "token"
    }

    auth_base_url()
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  defp auth_base_url(),
    do: Application.fetch_env!(:beeminder_withings_sync, :beeminder_auth_base_url)
end
