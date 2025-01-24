import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :beeminder_withings_sync, BeeminderWithingsSync.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 5433,
  database: "beeminder_withings_sync_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :beeminder_withings_sync, BeeminderWithingsSyncWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Ia77eEQcT+DjFsydoh87ZoTixCuYoAP63RjpwAvL2U+XVeeTBByQzWWnlMesBf9/",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :beeminder_withings_sync,
  beeminder_client_module: BeeminderWithingsSync.Beeminder.BeeminderClientMock,
  withings_client_module: BeeminderWithingsSync.Withings.WithingsClientMock,
  start_withings_token_refresher: false
