defmodule OrderIsComing.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :code, :integer
      add :description, :string
      add :value, :decimal, null: false

      timestamps()
    end
  end
end
