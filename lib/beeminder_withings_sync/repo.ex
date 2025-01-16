defmodule BeeminderWithingsSync.Repo do
  use Ecto.Repo,
    otp_app: :beeminder_withings_sync,
    adapter: Ecto.Adapters.Postgres
end
