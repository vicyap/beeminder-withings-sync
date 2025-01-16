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

    beeminder_base_url()
    |> URI.parse()
    |> Map.put(:path, "/apps/authorize")
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  def get_current_user(access_token) do
    params = %{access_token: access_token}

    beeminder_base_url()
    |> URI.parse()
    |> Map.put(:path, "/api/v1/users/me.json")
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
    |> HTTPoison.get()
    |> handle_response()
  end

  defp beeminder_base_url(),
    do: Application.fetch_env!(:beeminder_withings_sync, :beeminder_base_url)

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode(body)
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
