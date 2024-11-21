defmodule Munch.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :osm_type, :text
      add :osm_id, :bigint
      add :name, :text, null: false
      add :location, :geometry, null: false
      add :note, :text
      add :iso_country_subdivision, :text
      add :secondary_subdivision, :text

      timestamps(type: :utc_datetime)
    end
  end
end
