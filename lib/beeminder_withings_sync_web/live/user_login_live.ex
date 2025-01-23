defmodule BeeminderWithingsSyncWeb.UserLoginLive do
  use BeeminderWithingsSyncWeb, :live_view

  alias BeeminderWithingsSyncWeb.OAuthHelpers

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in with Beeminder
      </.header>

      <.link
        href={@beeminder_auth_url}
        class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
      >
        Sign in with Beeminder
      </.link>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    beeminder_auth_url =
      OAuthHelpers.beeminder_redirect_uri()
      |> BeeminderWithingsSync.Beeminder.auth_url()

    {:ok, assign(socket, beeminder_auth_url: beeminder_auth_url)}
  end
end
