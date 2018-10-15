defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tasks" do
    field :completed, :boolean, default: false
    field :created_at, :time
    field :desc, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :completed, :created_at])
    |> validate_required([:title, :desc, :completed, :created_at])
  end
end
