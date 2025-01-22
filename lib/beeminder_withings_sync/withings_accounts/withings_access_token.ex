defmodule BeeminderWithingsSync.WithingsAccounts.WithingsAccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "withings_access_tokens" do
    field :scope, :string
    field :access_token, :string
    field :refresh_token, :string
    field :expires_in, :integer
    field :token_type, :string
    field :withings_user_id, :string
    belongs_to :user, BeeminderWithingsSync.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(withings_access_token, attrs) do
    withings_access_token
    |> cast(attrs, [
      :access_token,
      :refresh_token,
      :expires_in,
      :scope,
      :token_type,
      :withings_user_id
    ])
    |> validate_required([
      :access_token,
      :refresh_token,
      :expires_in,
      :scope,
      :token_type,
      :withings_user_id
    ])
  end
end
