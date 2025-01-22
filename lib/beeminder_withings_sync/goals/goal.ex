defmodule BeeminderWithingsSync.Goals.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "goals" do
    field :slug, :string
    belongs_to :user, BeeminderWithingsSync.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:slug])
    |> validate_required([:slug])
  end
end
