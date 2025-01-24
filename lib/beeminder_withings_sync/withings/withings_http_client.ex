defmodule BeeminderWithingsSync.Withings.WithingsHTTPClient do
  @behaviour BeeminderWithingsSync.Withings.WithingsClient

  # def oauth2_request_token(refresh_token, grant_type = "refresh_token")
  #     when is_binary(refresh_token) do
  #   params = %{
  #     action: "requesttoken",
  #     client_id: Application.fetch_env!(:beeminder_withings_sync, :withings_client_id),
  #     client_secret: Application.fetch_env!(:beeminder_withings_sync, :withings_client_secret),
  #     grant_type: grant_type,
  #     refresh_token: refresh_token
  #   }
  #   body = Enum.map_join(params, "&", fn {k, v} -> "#{k}=#{v}" end)
  #   api_base_url()
  #   |> URI.parse()
  #   |> URI.append_path("/v2/oauth2")
  #   |> URI.to_string()
  #   |> HTTPoison.post(body)
  #   |> handle_response()
  # end

  def oauth2_request_token(code, grant_type = "authorization_code", redirect_uri)
      when is_binary(code) and is_binary(redirect_uri) do
    params = %{
      action: "requesttoken",
      client_id: Application.fetch_env!(:beeminder_withings_sync, :withings_client_id),
      client_secret: Application.fetch_env!(:beeminder_withings_sync, :withings_client_secret),
      grant_type: grant_type,
      code: code,
      redirect_uri: redirect_uri
    }

    body = Enum.map_join(params, "&", fn {k, v} -> "#{k}=#{v}" end)

    api_base_url()
    |> URI.parse()
    |> URI.append_path("/v2/oauth2")
    |> URI.to_string()
    |> HTTPoison.post(body)
    |> handle_response()
  end

  defp api_base_url(),
    do: Application.fetch_env!(:beeminder_withings_sync, :withings_api_base_url)

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    case Jason.decode(body) do
      {:ok, %{"status" => 0, "body" => body}} ->
        {:ok, body}

      {:ok, %{"status" => _status, "error" => error}} ->
        {:error, error}

      {:error, _} = error ->
        error
    end
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
