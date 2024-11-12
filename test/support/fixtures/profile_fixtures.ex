defmodule Munch.ProfileFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Munch.Profile` context.
  """

  @doc """
  Generate a featured_restaurant.
  """
  def featured_restaurant_fixture(attrs \\ %{}) do
    {:ok, featured_restaurant} =
      attrs
      |> Enum.into(%{
        position: 42
      })
      |> Munch.Profile.create_featured_restaurant()

    featured_restaurant
  end
end
