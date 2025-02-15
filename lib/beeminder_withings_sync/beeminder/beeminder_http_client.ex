defmodule BeeminderWithingsSync.Beeminder.BeeminderHTTPClient do
  @behaviour BeeminderWithingsSync.Beeminder.BeeminderClient

  def get_me(access_token) when is_binary(access_token) do
    params = %{access_token: access_token}

    api_base_url()
    |> URI.parse()
    |> URI.append_path("/users/me.json")
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
    |> HTTPoison.get()
    |> handle_response()
  end

  def get_user(username, auth_token)
      when is_binary(username) and is_binary(auth_token) do
    params = %{auth_token: auth_token}

    api_base_url()
    |> URI.parse()
    |> URI.append_path("/users/#{username}.json")
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
    |> HTTPoison.get()
    |> handle_response()
  end

  defp api_base_url(),
    do: Application.fetch_env!(:beeminder_withings_sync, :beeminder_api_base_url)

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode(body)
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
