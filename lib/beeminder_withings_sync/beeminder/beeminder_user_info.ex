defmodule BeeminderWithingsSync.Beeminder.BeeminderUserInfo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:username, :string, []}
  @foreign_key_type :binary_id
  schema "beeminder_user_infos" do
    field :access_token, :string
    belongs_to :user, BeeminderWithingsSync.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(beeminder_user_info, attrs) do
    beeminder_user_info
    |> cast(attrs, [:username, :access_token, :user_id])
    |> validate_required([:username, :access_token, :user_id])
  end
end
