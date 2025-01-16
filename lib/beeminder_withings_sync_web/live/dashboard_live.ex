defmodule BeeminderWithingsSyncWeb.DashboardLive do
  use BeeminderWithingsSyncWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, redirect(socket, to: ~p"/app/goals")}
  end
end
