defmodule TaskTrackerWeb.TimeBlockController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Tasks
  alias TaskTracker.Tasks.TimeBlock

  action_fallback TaskTrackerWeb.FallbackController

  def index(conn, _params) do
    time_blocks = Tasks.list_time_blocks()
    render(conn, "index.json", time_blocks: time_blocks)
  end

  def create(conn, %{"time_block" => time_block_params}) do
    {task_id, _} = Integer.parse(Map.get(time_block_params, "task_id"))
    task = Tasks.get_task!(task_id)
    redirect_location = Map.get(time_block_params, "redirect_location")
    with {:ok, %TimeBlock{} = time_block} <- Tasks.create_time_block(time_block_params) do
      conn = put_status(conn, :created)
      if redirect_location != nil do
        redirect_location = String.to_atom(redirect_location)
        conn
        |> put_resp_header("location", Routes.task_path(conn, redirect_location, task))
        |> redirect(to: Routes.task_path(conn, redirect_location, task))
      else
        conn
        |> send_resp(:no_content, "")
      end
    end
  end

  def show(conn, %{"id" => id}) do
    time_block = Tasks.get_time_block!(id)
    render(conn, "show.json", time_block: time_block)
  end

  def update(conn, %{"id" => id, "time_block" => time_block_params}) do
    time_block = Tasks.get_time_block!(id)

    with {:ok, %TimeBlock{} = time_block} <- Tasks.update_time_block(time_block, time_block_params) do
      render(conn, "show.json", time_block: time_block)
    end
  end

  def delete(conn, %{"time_block_id" => id, "redirect" => redirect}) do
    time_block = Tasks.get_time_block!(id)
    task = time_block.task
    with {:ok, %TimeBlock{}} <- Tasks.delete_time_block(time_block) do
      put_flash(conn, :info, "added")
      |> send_resp(:no_content, "")
    end
  end
end
