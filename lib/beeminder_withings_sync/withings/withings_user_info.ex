defmodule BeeminderWithingsSync.Withings.WithingsUserInfo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:withings_user_id, :string, []}
  @foreign_key_type :binary_id
  schema "withings_user_infos" do
    field :scope, :string
    field :access_token, :string
    field :refresh_token, :string
    field :expires_at, :utc_datetime
    field :token_type, :string
    field :csrf_token, :string
    belongs_to :user, BeeminderWithingsSync.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(withings_user_info, attrs) do
    withings_user_info
    |> cast(attrs, [
      :withings_user_id,
      :access_token,
      :refresh_token,
      :expires_at,
      :scope,
      :token_type,
      :csrf_token,
      :user_id
    ])
    |> validate_required([
      :withings_user_id,
      :access_token,
      :refresh_token,
      :expires_at,
      :scope,
      :token_type,
      :csrf_token,
      :user_id
    ])
  end
end
