# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :beeminder_withings_sync,
  ecto_repos: [BeeminderWithingsSync.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true],
  beeminder_base_url: System.get_env("BEEMINDER_BASE_URL", "https://www.beeminder.com"),
  beeminder_redirect_uri_path:
    System.get_env(
      "BEEMINDER_REDIRECT_URI_PATH",
      "/beeminder/auth_callback"
    ),
  beeminder_client_id: System.get_env("BEEMINDER_CLIENT_ID"),
  beeminder_client_secret: System.get_env("BEEMINDER_CLIENT_SECRET")

# Configures the endpoint
config :beeminder_withings_sync, BeeminderWithingsSyncWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BeeminderWithingsSyncWeb.ErrorHTML, json: BeeminderWithingsSyncWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: BeeminderWithingsSync.PubSub,
  live_view: [signing_salt: "llUC72em"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  beeminder_withings_sync: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  beeminder_withings_sync: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
