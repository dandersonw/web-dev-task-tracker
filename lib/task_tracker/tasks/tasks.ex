defmodule TaskTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo
  alias TaskTracker.Users
  alias TaskTracker.Users.User
  alias TaskTracker.Tasks.Task

  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(current_user, attrs \\ %{}) do
    case put_assignee(current_user, attrs) do
      {:error, reason} -> {:error, Ecto.Changeset.add_error(Task.changeset(%Task{}, attrs), :assign_to, reason)}
      attrs -> %Task{}
      |> Task.changeset(attrs)
      |> Repo.insert()
    end
  end

  def get_username_for_task(task) do
    case task.assignee do
      nil -> nil
      user_id -> Users.get_user!(user_id).name
    end
  end

  defp put_assignee(current_user, attrs) do
    case Map.get(attrs, "assign_to") do
      nil -> attrs
      "" -> attrs
      username ->
        user = Users.get_user_by_name(username)
        case user do
          nil -> {:error, "unknown user"}
          found ->
            if current_user != nil and found.manager == current_user.id do
              Map.put(attrs, "assignee", found.id)
            else
              {:error, "You're not that user's manager"}
            end
        end
    end
  end

  def get_tasks(user, all_users, completed) do
    case {user, all_users, completed} do
      {nil, _, completed} -> Repo.all(from(t in Task, where: not ^completed or t.completed == false))
      {_, "all", completed} -> Repo.all(from(t in Task, where: (^completed or t.completed == false)))
      {user, "my", completed} -> Repo.all(from(t in Task, where: t.assignee == ^user.id and (^completed or t.completed == false)))
      {user, "underling", completed} ->
        q = from(t in Task, join: u in User, where: u.id == t.assignee)
        Repo.all(from([t, u] in q, select: t, where: u.manager == ^user.id and (^completed or t.completed == false)))
    end
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(current_user, %Task{} = task, attrs) do
    case put_assignee(current_user, attrs) do
      {:error, reason} -> {:error, Ecto.Changeset.add_error(Task.changeset(task, attrs), :assign_to, reason)}
      attrs -> task
      |> Task.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
