defmodule BeeminderWithingsSync.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :beeminder_username, :string

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for creation.
  """
  def create_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:beeminder_username])
    |> validate_beeminder_username(opts)
  end

  defp validate_beeminder_username(changeset, _opts) do
    changeset
    |> validate_required([:beeminder_username])
    |> unique_constraint(:beeminder_username)
  end
end
