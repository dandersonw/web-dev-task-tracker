defmodule TaskTrackerWeb.TaskController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Tasks
  alias TaskTracker.Tasks.Task


  @index_optional_params %{"which_users" => "my", "completed" => "false"}

  def index(conn, params) do
    params = Map.merge(@index_optional_params, params)
    case params do
      %{"which_users" => which_users, "completed" => completed} ->
        completed = String.to_existing_atom(completed)
        tasks = Tasks.get_tasks(conn.assigns.current_user, which_users, completed)
        render(conn, "index.html", tasks: tasks, which_users: which_users, completed: completed)
    end
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(conn.assigns.current_user, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def show_completion_form(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    render(conn, "complete.html", task: task, changeset: changeset, current_user: conn.assigns.current_user)
  end

  def complete(conn, %{"id" => id, "task" => task_params}) do
    {hours_spent, _} = Integer.parse(Map.get(task_params, "time_spent_hours"))
    {minutes_spent, _} =  Integer.parse(Map.get(task_params, "time_spent_minutes"))
    time_spent = hours_spent * 60 + minutes_spent

    task = Tasks.get_task!(id)
    task_params = task_params
    |> Map.put("completed", true)
    |> Map.put("time_spent", time_spent)
    case Tasks.update_task(conn.assigns.current_user, task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task completed successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "complete.html", task: task, changeset: changeset, current_user: conn.assigns.current_user)
    end
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    case Tasks.update_task(conn.assigns.current_user, task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
