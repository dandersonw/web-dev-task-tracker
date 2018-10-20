defmodule TaskTracker.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :manager, :id
    field :is_manager, :boolean

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :manager, :is_manager])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
