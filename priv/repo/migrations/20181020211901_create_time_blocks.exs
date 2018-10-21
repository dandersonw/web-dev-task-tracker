defmodule TaskTracker.Repo.Migrations.CreateTimeBlocks do
  use Ecto.Migration

  def change do
    create table(:time_blocks) do
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end

    alter table(:tasks) do
      remove :time_spent
    end

    create index(:time_blocks, [:task_id])
  end
end
