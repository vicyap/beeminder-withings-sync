defmodule BeeminderWithingsSyncWeb.DashboardLive do
  use BeeminderWithingsSyncWeb, :live_view

  alias BeeminderWithingsSyncWeb.OAuthHelpers

  import BeeminderWithingsSyncWeb.MyComponents

  def render(assigns) do
    ~H"""
    <.app_home></.app_home>
    <.link
      href={@withings_auth_url}
      class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
    >
      Authorize Withings
    </.link>
    """
  end

  def mount(_params, _session, socket) do
    withings_auth_url =
      OAuthHelpers.withings_redirect_uri()
      |> BeeminderWithingsSync.Withings.auth_url()

    {:ok, assign(socket, withings_auth_url: withings_auth_url)}
  end
end
