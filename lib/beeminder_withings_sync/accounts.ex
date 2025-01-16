defmodule BeeminderWithingsSync.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BeeminderWithingsSync.Repo

  alias BeeminderWithingsSync.Accounts.{User, UserToken}

  ## Database getters

  @doc """
  Gets a user by beeminder username.

  ## Examples

      iex> get_user_by_beeminder_username("foo")
      %User{}

      iex> get_user_by_beeminder_username("unknown")
      nil

  """
  def get_user_by_beeminder_username(username) when is_binary(username) do
    Repo.get_by(User, beeminder_username: username)
  end

  @doc """
  Gets or creates a user by beeminder username.

  ## Examples

      iex> get_or_create_user_by_beeminder_username("foo")
      {:ok, %User{}}

      iex> get_or_create_user_by_beeminder_username("unknown")
      {:ok, %User{}}
  """
  def get_or_create_user_by_beeminder_username(username) when is_binary(username) do
    case get_user_by_beeminder_username(username) do
      nil ->
        create_user(%{beeminder_username: username})

      user ->
        {:ok, user}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User creation

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end
end
