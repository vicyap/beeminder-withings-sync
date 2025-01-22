defmodule BeeminderWithingsSync.WithingsAccounts do
  @moduledoc """
  The WithingsAccounts context.
  """

  import Ecto.Query, warn: false
  alias BeeminderWithingsSync.Repo

  alias BeeminderWithingsSync.WithingsAccounts.WithingsAccessToken

  @doc """
  Returns the list of withings_access_tokens.

  ## Examples

      iex> list_withings_access_tokens()
      [%WithingsAccessToken{}, ...]

  """
  def list_withings_access_tokens do
    Repo.all(WithingsAccessToken)
  end

  @doc """
  Gets a single withings_access_token.

  Raises `Ecto.NoResultsError` if the Withings access token does not exist.

  ## Examples

      iex> get_withings_access_token!(123)
      %WithingsAccessToken{}

      iex> get_withings_access_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_withings_access_token!(id), do: Repo.get!(WithingsAccessToken, id)

  @doc """
  Creates a withings_access_token.

  ## Examples

      iex> create_withings_access_token(%{field: value})
      {:ok, %WithingsAccessToken{}}

      iex> create_withings_access_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_withings_access_token(attrs \\ %{}) do
    %WithingsAccessToken{}
    |> WithingsAccessToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a withings_access_token.

  ## Examples

      iex> update_withings_access_token(withings_access_token, %{field: new_value})
      {:ok, %WithingsAccessToken{}}

      iex> update_withings_access_token(withings_access_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_withings_access_token(%WithingsAccessToken{} = withings_access_token, attrs) do
    withings_access_token
    |> WithingsAccessToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a withings_access_token.

  ## Examples

      iex> delete_withings_access_token(withings_access_token)
      {:ok, %WithingsAccessToken{}}

      iex> delete_withings_access_token(withings_access_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_withings_access_token(%WithingsAccessToken{} = withings_access_token) do
    Repo.delete(withings_access_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking withings_access_token changes.

  ## Examples

      iex> change_withings_access_token(withings_access_token)
      %Ecto.Changeset{data: %WithingsAccessToken{}}

  """
  def change_withings_access_token(%WithingsAccessToken{} = withings_access_token, attrs \\ %{}) do
    WithingsAccessToken.changeset(withings_access_token, attrs)
  end
end
