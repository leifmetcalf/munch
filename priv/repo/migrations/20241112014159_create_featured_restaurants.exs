defmodule Munch.Repo.Migrations.CreateFeaturedRestaurants do
  use Ecto.Migration

  def change do
    create table(:featured_restaurants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :position, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      add :restaurant_id, references(:restaurants, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:featured_restaurants, [:user_id])
    create index(:featured_restaurants, [:restaurant_id])
  end
end
