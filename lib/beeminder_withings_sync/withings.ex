defmodule BeeminderWithingsSync.Withings do
  @moduledoc """
  The Withings context.
  """

  import Ecto.Query, warn: false
  alias BeeminderWithingsSync.Repo

  alias BeeminderWithingsSync.Withings.WithingsUserInfo

  @doc """
  Returns the Withings authorization URL.
  """
  def auth_url(redirect_uri) do
    params = %{
      client_id: Application.fetch_env!(:beeminder_withings_sync, :withings_client_id),
      redirect_uri: redirect_uri,
      response_type: "code",
      scope: "user.info,user.metrics",
      state: "random_state"
    }

    Application.fetch_env!(:beeminder_withings_sync, :withings_auth_base_url)
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  @doc """
  Returns the list of withings_user_infos.

  ## Examples

      iex> list_withings_user_infos()
      [%WithingsUserInfo{}, ...]

  """
  def list_withings_user_infos do
    Repo.all(WithingsUserInfo)
  end

  @doc """
  Gets a single withings_user_info.

  Raises `Ecto.NoResultsError` if the Withings user info does not exist.

  ## Examples

      iex> get_withings_user_info!("userid")
      %WithingsUserInfo{}

      iex> get_withings_user_info!("unknown")
      ** (Ecto.NoResultsError)

  """
  def get_withings_user_info!(withings_user_id), do: Repo.get!(WithingsUserInfo, withings_user_id)

  def get_withings_user_info(withings_user_id) do
    Repo.get(WithingsUserInfo, withings_user_id)
  end

  @doc """
  Creates a withings_user_info.

  ## Examples

      iex> create_withings_user_info(%{field: value})
      {:ok, %WithingsUserInfo{}}

      iex> create_withings_user_info(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_withings_user_info(attrs \\ %{}) do
    %WithingsUserInfo{}
    |> WithingsUserInfo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a withings_user_info.

  ## Examples

      iex> update_withings_user_info(withings_user_info, %{field: new_value})
      {:ok, %WithingsUserInfo{}}

      iex> update_withings_user_info(withings_user_info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_withings_user_info(%WithingsUserInfo{} = withings_user_info, attrs) do
    withings_user_info
    |> WithingsUserInfo.changeset(attrs)
    |> Repo.update()
  end

  def insert_or_update_withings_user_info_by_user_id(user_id, attrs, opts \\ []) do
    # TODO: replace attrs with a struct returned by withings_client.oauth2_request_token
    attrs =
      attrs
      |> Map.put(
        "expires_at",
        DateTime.utc_now() |> DateTime.add(attrs["expires_in"], :second)
      )
      |> Map.put(
        "withings_user_id",
        Map.get(attrs, "userid")
      )

    case Repo.get_by(WithingsUserInfo, user_id: user_id) do
      nil ->
        %WithingsUserInfo{user_id: user_id}

      withings_user_info ->
        withings_user_info
    end
    |> WithingsUserInfo.changeset(attrs)
    |> Repo.insert_or_update()
    |> case do
      {:ok, withings_user_info} ->
        {:ok, Repo.preload(withings_user_info, opts[:preloads] || [])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a withings_user_info.

  ## Examples

      iex> delete_withings_user_info(withings_user_info)
      {:ok, %WithingsUserInfo{}}

      iex> delete_withings_user_info(withings_user_info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_withings_user_info(%WithingsUserInfo{} = withings_user_info) do
    Repo.delete(withings_user_info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking withings_user_info changes.

  ## Examples

      iex> change_withings_user_info(withings_user_info)
      %Ecto.Changeset{data: %WithingsUserInfo{}}

  """
  def change_withings_user_info(%WithingsUserInfo{} = withings_user_info, attrs \\ %{}) do
    WithingsUserInfo.changeset(withings_user_info, attrs)
  end
end
