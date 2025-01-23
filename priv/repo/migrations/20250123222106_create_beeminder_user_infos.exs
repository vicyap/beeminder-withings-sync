defmodule BeeminderWithingsSync.Repo.Migrations.CreateBeeminderUserInfos do
  use Ecto.Migration

  def change do
    create table(:beeminder_user_infos, primary_key: false) do
      add :username, :string, primary_key: true
      add :access_token, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:beeminder_user_infos, [:username])
    create index(:beeminder_user_infos, [:user_id])
  end
end
