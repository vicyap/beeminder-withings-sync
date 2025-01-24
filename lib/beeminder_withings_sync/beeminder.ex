defmodule BeeminderWithingsSync.Beeminder do
  @moduledoc """
  The Beeminder context.
  """

  import Ecto.Query, warn: false
  alias BeeminderWithingsSync.Repo

  alias BeeminderWithingsSync.Accounts
  alias BeeminderWithingsSync.Beeminder.BeeminderUserInfo

  @doc """
  Returns the Beeminder authorization URL.
  """
  def auth_url(redirect_uri) do
    params = %{
      client_id: Application.fetch_env!(:beeminder_withings_sync, :beeminder_client_id),
      redirect_uri: redirect_uri,
      response_type: "token"
    }

    Application.fetch_env!(:beeminder_withings_sync, :beeminder_auth_base_url)
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  @doc """
  Returns the list of beeminder_user_infos.

  ## Examples

      iex> list_beeminder_user_infos()
      [%BeeminderUserInfo{}, ...]

  """
  def list_beeminder_user_infos do
    Repo.all(BeeminderUserInfo)
  end

  @doc """
  Gets a single beeminder_user_info.

  Raises `Ecto.NoResultsError` if the Beeminder user info does not exist.

  ## Examples

      iex> get_beeminder_user_info!("username")
      %BeeminderUserInfo{}

      iex> get_beeminder_user_info!("unknown")
      ** (Ecto.NoResultsError)

  """
  def get_beeminder_user_info!(username), do: Repo.get!(BeeminderUserInfo, username)

  @doc """
  Gets a single beeminder_user_info.

  ## Examples

      iex> get_beeminder_user_info("username")
      %BeeminderUserInfo{}

      iex> get_beeminder_user_info("unknown")
      nil

  """
  def get_beeminder_user_info(username), do: Repo.get(BeeminderUserInfo, username)

  @doc """
  Creates a beeminder_user_info.

  ## Examples

      iex> create_beeminder_user_info(%{field: value})
      {:ok, %BeeminderUserInfo{}}

      iex> create_beeminder_user_info(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_beeminder_user_info(attrs \\ %{}) do
    %BeeminderUserInfo{}
    |> BeeminderUserInfo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a beeminder_user_info.

  ## Examples

      iex> update_beeminder_user_info(beeminder_user_info, %{field: new_value})
      {:ok, %BeeminderUserInfo{}}

      iex> update_beeminder_user_info(beeminder_user_info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_beeminder_user_info(%BeeminderUserInfo{} = beeminder_user_info, attrs) do
    beeminder_user_info
    |> BeeminderUserInfo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Inserts or updates a beeminder_user_info by username. Requires access_token.
  """
  def insert_or_update_beeminder_user_info_by_username(username, access_token, opts \\ [])
      when is_binary(username) and is_binary(access_token) do
    case Repo.get(BeeminderUserInfo, username) do
      nil ->
        {:ok, user} = Accounts.create_user(%{})
        %BeeminderUserInfo{username: username, user_id: user.id}

      beeminder_user_info ->
        beeminder_user_info
    end
    |> BeeminderUserInfo.changeset(%{access_token: access_token})
    |> Repo.insert_or_update()
    |> case do
      {:ok, beeminder_user_info} ->
        {:ok, Repo.preload(beeminder_user_info, opts[:preloads] || [])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a beeminder_user_info.

  ## Examples

      iex> delete_beeminder_user_info(beeminder_user_info)
      {:ok, %BeeminderUserInfo{}}

      iex> delete_beeminder_user_info(beeminder_user_info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_beeminder_user_info(%BeeminderUserInfo{} = beeminder_user_info) do
    Repo.delete(beeminder_user_info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking beeminder_user_info changes.

  ## Examples

      iex> change_beeminder_user_info(beeminder_user_info)
      %Ecto.Changeset{data: %BeeminderUserInfo{}}

  """
  def change_beeminder_user_info(%BeeminderUserInfo{} = beeminder_user_info, attrs \\ %{}) do
    BeeminderUserInfo.changeset(beeminder_user_info, attrs)
  end
end
