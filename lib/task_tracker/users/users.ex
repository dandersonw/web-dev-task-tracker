defmodule TaskTracker.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def get_underlings(user) do
    Repo.all(from(u in User, where: u.manager == ^user.id))
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

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_name(name), do: Repo.get_by(User, name: name)

  def get_user_by_name!(name), do: Repo.get_by!(User, name: name)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    changeset = %User{}
    |> User.changeset(attrs)
    case put_manager(changeset, attrs) do
      :error -> {:error, Ecto.Changeset.add_error(changeset, :manager_name, "unknown user")}
      changeset -> Repo.insert(changeset)
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    changeset = user
    |> User.changeset(attrs)
    case put_manager(changeset, attrs) do
      {:error, reason} -> {:error, Ecto.Changeset.add_error(changeset, :manager_name, reason)}
      changeset -> Repo.update(changeset)
    end
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  defp put_manager(changeset, attrs) do
    case Map.get(attrs, "manager_name") do
      nil -> changeset
      "" -> changeset
      username ->
        user = get_user_by_name(username)
        case user do
          nil -> {:error, "unknown user"}
          found ->
            if found.is_manager do
              Ecto.Changeset.put_change(changeset, :manager, found.id)
            else
              {:error, "not a manager"}
            end
        end
    end
  end

end
