defmodule BeeminderWithingsSyncWeb.UserLoginLive do
  use BeeminderWithingsSyncWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in with Beeminder
      </.header>

      <.link
        href={BeeminderWithingsSync.Beeminder.auth_url()}
        class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
      >
        Sign in with Beeminder
      </.link>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
