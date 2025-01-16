defmodule BeeminderWithingsSyncWeb.UserLoginLive do
  use BeeminderWithingsSyncWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in to account
      </.header>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
