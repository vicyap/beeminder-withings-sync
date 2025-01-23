defmodule BeeminderWithingsSync.Repo.Migrations.CreateWithingsUserInfos do
  use Ecto.Migration

  def change do
    create table(:withings_user_infos, primary_key: false) do
      add :withings_user_id, :string, primary_key: true
      add :access_token, :string
      add :refresh_token, :string
      add :expires_at, :utc_datetime
      add :scope, :string
      add :token_type, :string
      add :csrf_token, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:withings_user_infos, [:withings_user_id])
    create index(:withings_user_infos, [:user_id])
  end
end
