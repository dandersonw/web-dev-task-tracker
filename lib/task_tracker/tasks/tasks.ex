defmodule TaskTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo
  alias TaskTracker.Users
  alias TaskTracker.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
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
    Repo.transaction(fn ->
      task = %Task{}
      |> Task.changeset(attrs)
      |> Repo.insert!()
      case maybe_assign_task_to_username(attrs, task) do
        nil -> task
        {:error, reason} -> Repo.rollback(reason)
        {:ok, _} -> task
      end
    end)
  end

  def maybe_assign_task_to_username(attrs, task) do
    case Map.fetch(attrs, "assign_to") do
            {:ok, username} ->
              assign_task_to_username(task, username)
            {:error, _} -> nil
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
    Repo.transaction(fn ->
      task = task
      |> Task.changeset(attrs)
      |> Repo.update!()
      case maybe_assign_task_to_username(attrs, task) do
        nil -> task
        {:error, reason} -> Repo.rollback(reason)
        {:ok, _} -> task
      end
    end)
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

  alias TaskTracker.Tasks.Assignment

  @doc """
  Returns the list of assignments.

  ## Examples

      iex> list_assignments()
      [%Assignment{}, ...]

  """
  def list_assignments do
    Repo.all(Assignment)
  end

  @doc """
  Gets a single assignment.

  Raises `Ecto.NoResultsError` if the Assignment does not exist.

  ## Examples

      iex> get_assignment!(123)
      %Assignment{}

      iex> get_assignment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_assignment!(id), do: Repo.get!(Assignment, id)

  @doc """
  Creates a assignment.

  ## Examples

      iex> create_assignment(%{field: value})
      {:ok, %Assignment{}}

      iex> create_assignment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_assignment(attrs \\ %{}) do
    %Assignment{}
    |> Assignment.changeset(attrs)
    |> Repo.insert()
  end

  def assign_task_to_username(task, username) do
    case Users.get_user_by_name(username) do
      nil -> {:error, "no user by that name"}
      user -> create_assignment(%{"user_id" => user.id,
                                 "task_id" => task.id,
                                 "created_at" => DateTime.utc_now})
    end
  end

  def get_username_for_task(task) do
    case get_assignment_for_task(task) do
      {:ok, assignment} ->
        case Users.get_user(assignment.user_id) do
          {:ok, user} -> user.name
        end
      nil -> nil
    end
  end

  def get_assignment_for_task(task) do
    Repo.get_by(Assignment, task_id: task.id)
  end

  @doc """
  Updates a assignment.

  ## Examples

      iex> update_assignment(assignment, %{field: new_value})
      {:ok, %Assignment{}}

      iex> update_assignment(assignment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_assignment(%Assignment{} = assignment, attrs) do
    assignment
    |> Assignment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Assignment.

  ## Examples

      iex> delete_assignment(assignment)
      {:ok, %Assignment{}}

      iex> delete_assignment(assignment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_assignment(%Assignment{} = assignment) do
    Repo.delete(assignment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking assignment changes.

  ## Examples

      iex> change_assignment(assignment)
      %Ecto.Changeset{source: %Assignment{}}

  """
  def change_assignment(%Assignment{} = assignment) do
    Assignment.changeset(assignment, %{})
  end
end
