defmodule Munch.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :osm_type, :text
      add :osm_id, :bigint
      add :name, :text, null: false
      add :display_name, :text
      add :location, :geometry, null: false
      add :note, :text
      add :country, :text
      add :iso_country_subdivision, :text
      add :address, :map
      timestamps(type: :utc_datetime)
    end

    create unique_index(:restaurants, [:osm_type, :osm_id])
  end
end
