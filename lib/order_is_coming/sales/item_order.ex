defmodule OrderIsComing.Sales.ItemOrder do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrderIsComing.Sales.{Item, Order}

  schema "items_orders" do
    belongs_to :item, Item
    belongs_to :order, Order

    timestamps()
  end

  @required_fields ~w(item_id order_id)a

  @doc false
  def changeset(item_order, attrs) do
    item_order
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
