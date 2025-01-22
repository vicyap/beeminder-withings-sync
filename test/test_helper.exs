ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BeeminderWithingsSync.Repo, :manual)

Mox.defmock(BeeminderWithingsSync.BeeminderClientMock,
  for: BeeminderWithingsSync.BeeminderClient
)
