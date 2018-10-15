defmodule TaskTracker.Tasks.Assignment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "assignments" do
    field :created_at, :time
    field :user_id, :id
    field :task_id, :id

    timestamps()
  end

  @doc false
  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, [:created_at])
    |> validate_required([:created_at])
  end
end
