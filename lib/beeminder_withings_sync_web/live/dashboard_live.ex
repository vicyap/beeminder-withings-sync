defmodule BeeminderWithingsSyncWeb.DashboardLive do
  use BeeminderWithingsSyncWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Authorize Withings
      </.header>

      <.link
        href={BeeminderWithingsSync.Withings.auth_url()}
        class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
      >
        Authorize Withings
      </.link>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
