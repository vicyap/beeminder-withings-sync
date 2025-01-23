defmodule BeeminderWithingsSyncWeb.WithingsController do
  use BeeminderWithingsSyncWeb, :controller

  alias BeeminderWithingsSyncWeb.OAuthHelpers

  def auth_callback(conn, %{"code" => code, "state" => state}) do
    # TODO: verify state
    IO.puts("TODO: verify state: #{state}")

    withings_client = Application.get_env(:beeminder_withings_sync, :withings_client_module)

    case withings_client.oauth2_request_token(
           code,
           "authorization_code",
           OAuthHelpers.withings_redirect_uri()
         ) do
      {:ok,
       %{
         "access_token" => access_token,
         "refresh_token" => refresh_token,
         "expires_in" => expires_in,
         "scope" => scope,
         "token_type" => token_type,
         "userid" => user_id
       }} ->
        IO.inspect(
          access_token: access_token,
          refresh_token: refresh_token,
          expires_in: expires_in,
          scope: scope,
          token_type: token_type,
          user_id: user_id
        )

        # TODO: save withings access tokens to database

        redirect(conn, to: ~p"/app")

      {:error, reason} ->
        IO.puts("Error: #{reason}")
        redirect(conn, to: ~p"/users/log_in")
    end
  end

  def auth_callback(conn, _params) do
    redirect(conn, to: ~p"/users/log_in")
  end
end
