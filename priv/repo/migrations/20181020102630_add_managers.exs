defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :manager, references(:users, on_delete: :nothing)
      add :is_manager, :boolean, default: false, null: false
    end
  end

end
