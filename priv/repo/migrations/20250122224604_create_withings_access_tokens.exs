defmodule BeeminderWithingsSync.Repo.Migrations.CreateWithingsAccessTokens do
  use Ecto.Migration

  def change do
    create table(:withings_access_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :access_token, :string
      add :refresh_token, :string
      add :expires_in, :integer
      add :scope, :string
      add :token_type, :string
      add :withings_user_id, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:withings_access_tokens, [:user_id])
  end
end
