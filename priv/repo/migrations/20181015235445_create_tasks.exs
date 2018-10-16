defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :desc, :text
      add :completed, :boolean, default: false, null: false
      add :time_spent, :integer
      add :assignee, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:assignee])
  end
end
