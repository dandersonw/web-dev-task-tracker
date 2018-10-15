defmodule TaskTracker.Repo.Migrations.CreateAssignments do
  use Ecto.Migration

  def change do
    create table(:assignments) do
      add :created_at, :time
      add :user_id, references(:users, on_delete: :nothing)
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end

    create index(:assignments, [:user_id])
    create index(:assignments, [:task_id])
  end
end
