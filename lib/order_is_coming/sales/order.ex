defmodule OrderIsComing.Sales.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrderIsComing.Accounts.User
  alias OrderIsComing.Sales.Item

  schema "orders" do
    field :value, :decimal
    belongs_to :user, User, on_replace: :raise
    many_to_many :items, Item, join_through: "items_orders"
    # field :item_ids, {:array, :integer}, virtual: true

    timestamps()
  end

  @required_fields ~w(value user_id)a
  # @optional_fields ~w(user_id)a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields)
    |> validate_required([:user_id])
  end
end
