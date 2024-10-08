defmodule Munch.RestaurantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Munch.Restaurants` context.
  """

  @doc """
  Generate a restaurant.
  """
  def restaurant_fixture(attrs \\ %{}) do
    {:ok, restaurant} =
      attrs
      |> Enum.into(%{
        address: "some address",
        name: "some name"
      })
      |> Munch.Restaurants.create_restaurant()

    restaurant
  end
end
