defmodule OrderIsComing.Sales.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :value, :decimal

    timestamps()
  end

  @required_fields ~w(name value code)a

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :value, :code, :description])
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 2)
    |> unique_constraint(:code)
  end
end
