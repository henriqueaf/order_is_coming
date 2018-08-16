defmodule OrderIsComing.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :value, :decimal
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:orders, [:user_id])
  end
end
