ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BeeminderWithingsSync.Repo, :manual)

Mox.defmock(BeeminderWithingsSync.Beeminder.BeeminderClientMock,
  for: BeeminderWithingsSync.Beeminder.BeeminderClient
)

Mox.defmock(BeeminderWithingsSync.Withings.WithingsClientMock,
  for: BeeminderWithingsSync.Withings.WithingsClient
)
