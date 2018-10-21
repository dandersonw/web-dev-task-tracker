defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false
    field :desc, :string
    field :title, :string
    field :assignee, :id
    has_many :blocks, TaskTracker.Tasks.TimeBlock
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :completed, :assignee])
    |> validate_required([:title, :desc])
  end
end
