defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false
    field :desc, :string
    field :time_spent, :integer
    field :title, :string
    field :assignee, :id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :completed, :time_spent, :assignee])
    |> validate_required([:title, :desc])
    |> validate_number(:time_spent, greater_than: 0)
  end
end
