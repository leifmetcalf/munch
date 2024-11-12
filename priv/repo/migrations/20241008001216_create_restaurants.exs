defmodule Munch.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :address, :string, null: false
      add :country, :string, null: false
      add :city, :string, null: false
      add :neighbourhood, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
