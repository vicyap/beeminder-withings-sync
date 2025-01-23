defmodule BeeminderWithingsSync.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    timestamps(type: :utc_datetime)

    has_one :beeminder_user_info, BeeminderWithingsSync.Beeminder.BeeminderUserInfo
    has_one :withings_user_info, BeeminderWithingsSync.Withings.WithingsUserInfo
  end

  @doc """
  A user changeset for creation.
  """
  def create_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
