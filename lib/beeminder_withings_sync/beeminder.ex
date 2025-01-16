defmodule BeeminderWithingsSync.Beeminder do
  def auth_url() do
    redirect_uri_path =
      Application.fetch_env!(:beeminder_withings_sync, :beeminder_redirect_uri_path)

    redirect_uri =
      BeeminderWithingsSyncWeb.Endpoint.url()
      |> Path.join(redirect_uri_path)

    params = %{
      client_id: Application.fetch_env!(:beeminder_withings_sync, :beeminder_client_id),
      redirect_uri: redirect_uri,
      response_type: "token"
    }

    Application.fetch_env!(:beeminder_withings_sync, :beeminder_base_url)
    |> URI.parse()
    |> Map.put(:path, "/apps/authorize")
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end
end
