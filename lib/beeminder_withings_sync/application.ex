defmodule BeeminderWithingsSync.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BeeminderWithingsSyncWeb.Telemetry,
      BeeminderWithingsSync.Repo,
      {DNSCluster, query: Application.get_env(:beeminder_withings_sync, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BeeminderWithingsSync.PubSub},
      # Start a worker by calling: BeeminderWithingsSync.Worker.start_link(arg)
      # {BeeminderWithingsSync.Worker, arg},
      # Start to serve requests, typically the last entry
      BeeminderWithingsSyncWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BeeminderWithingsSync.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BeeminderWithingsSyncWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
