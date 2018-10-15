defmodule TaskTracker.TasksTest do
  use TaskTracker.DataCase

  alias TaskTracker.Tasks

  describe "tasks" do
    alias TaskTracker.Tasks.Task

    @valid_attrs %{completed: true, created_at: ~T[14:00:00.000000], desc: "some desc", title: "some title"}
    @update_attrs %{completed: false, created_at: ~T[15:01:01.000000], desc: "some updated desc", title: "some updated title"}
    @invalid_attrs %{completed: nil, created_at: nil, desc: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Tasks.create_task(@valid_attrs)
      assert task.completed == true
      assert task.created_at == ~T[14:00:00.000000]
      assert task.desc == "some desc"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)

      
      assert task.completed == false
      assert task.created_at == ~T[15:01:01.000000]
      assert task.desc == "some updated desc"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "assignments" do
    alias TaskTracker.Tasks.Assignment

    @valid_attrs %{created_at: ~T[14:00:00.000000]}
    @update_attrs %{created_at: ~T[15:01:01.000000]}
    @invalid_attrs %{created_at: nil}

    def assignment_fixture(attrs \\ %{}) do
      {:ok, assignment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_assignment()

      assignment
    end

    test "list_assignments/0 returns all assignments" do
      assignment = assignment_fixture()
      assert Tasks.list_assignments() == [assignment]
    end

    test "get_assignment!/1 returns the assignment with given id" do
      assignment = assignment_fixture()
      assert Tasks.get_assignment!(assignment.id) == assignment
    end

    test "create_assignment/1 with valid data creates a assignment" do
      assert {:ok, %Assignment{} = assignment} = Tasks.create_assignment(@valid_attrs)
      assert assignment.created_at == ~T[14:00:00.000000]
    end

    test "create_assignment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_assignment(@invalid_attrs)
    end

    test "update_assignment/2 with valid data updates the assignment" do
      assignment = assignment_fixture()
      assert {:ok, %Assignment{} = assignment} = Tasks.update_assignment(assignment, @update_attrs)

      
      assert assignment.created_at == ~T[15:01:01.000000]
    end

    test "update_assignment/2 with invalid data returns error changeset" do
      assignment = assignment_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_assignment(assignment, @invalid_attrs)
      assert assignment == Tasks.get_assignment!(assignment.id)
    end

    test "delete_assignment/1 deletes the assignment" do
      assignment = assignment_fixture()
      assert {:ok, %Assignment{}} = Tasks.delete_assignment(assignment)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_assignment!(assignment.id) end
    end

    test "change_assignment/1 returns a assignment changeset" do
      assignment = assignment_fixture()
      assert %Ecto.Changeset{} = Tasks.change_assignment(assignment)
    end
  end
end
