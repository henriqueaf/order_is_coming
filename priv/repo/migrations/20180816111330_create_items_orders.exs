defmodule OrderIsComing.Repo.Migrations.CreateItemsOrders do
  use Ecto.Migration

  def change do
    create table(:items_orders) do
      add :item_id, references(:items, on_delete: :delete_all)
      add :order_id, references(:orders, on_delete: :delete_all)

      timestamps()
    end

    create index(:items_orders, [:item_id])
    create index(:items_orders, [:order_id])
    create unique_index(:items_orders, [:item_id, :order_id])
  end
end
