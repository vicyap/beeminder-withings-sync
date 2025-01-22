defmodule BeeminderWithingsSync.BeeminderHTTPClient do
  @behaviour BeeminderWithingsSync.BeeminderClient

  alias BeeminderWithingsSync.Beeminder

  def get_current_user(access_token) when is_binary(access_token) do
    params = %{access_token: access_token}

    Beeminder.beeminder_base_url()
    |> URI.parse()
    |> Map.put(:path, "/api/v1/users/me.json")
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
    |> HTTPoison.get()
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode(body)
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
