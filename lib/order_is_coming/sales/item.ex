defmodule OrderIsComing.Sales.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrderIsComing.Sales.Order

  schema "items" do
    field :code, :integer
    field :description, :string
    field :name, :string
    field :value, :decimal
    many_to_many :orders, Order, join_through: "items_orders"
    # has_many :items_orders, OrderIsComing.Sales.ItemOrder
    # has_many :orders, through: [:items_orders, :orders]

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
