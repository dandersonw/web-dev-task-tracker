defmodule TaskTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo
  alias TaskTracker.Users
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
  def create_task(attrs \\ %{}) do
    case put_assignee(attrs) do
      :error -> {:error, Task.changeset(%Task{}, attrs)}
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

  def put_assignee(attrs) do
    case Map.get(attrs, "assign_to") do
      nil -> attrs
      "" -> attrs
      username ->
        user = Users.get_user_by_name(username)
        case user do
          nil -> :error
          found -> Map.put(attrs, "assignee", found.id)
        end
    end
  end

  def get_tasks(user, all_users, completed) do
    case {user, all_users, completed} do
      {nil, _, completed} -> Repo.all(from(t in Task, where: not ^completed or t.completed == false))
      {user, all_users, completed} -> Repo.all(from(t in Task, where: (^all_users or t.assignee == ^user.id) and (^completed or t.completed == false)))
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
  def update_task(%Task{} = task, attrs) do
    case put_assignee(attrs) do
      :error -> Task.changeset(task, attrs)
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
