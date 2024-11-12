defmodule Munch.Repo.Migrations.CreateListItems do
  use Ecto.Migration

  def change do
    create table(:list_items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :position, :integer, null: false
      add :list_id, references(:lists, on_delete: :delete_all, type: :binary_id), null: false

      add :restaurant_id, references(:restaurants, on_delete: :restrict, type: :binary_id),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:list_items, [:list_id])
    create index(:list_items, [:restaurant_id])
  end
end
