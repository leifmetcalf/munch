defmodule Munch.ProfileTest do
  use Munch.DataCase

  alias Munch.Profile

  describe "featured_restaurants" do
    alias Munch.Profile.FeaturedRestaurant

    import Munch.ProfileFixtures

    @invalid_attrs %{position: nil}

    test "list_featured_restaurants/0 returns all featured_restaurants" do
      featured_restaurant = featured_restaurant_fixture()
      assert Profile.list_featured_restaurants() == [featured_restaurant]
    end

    test "get_featured_restaurant!/1 returns the featured_restaurant with given id" do
      featured_restaurant = featured_restaurant_fixture()
      assert Profile.get_featured_restaurant!(featured_restaurant.id) == featured_restaurant
    end

    test "create_featured_restaurant/1 with valid data creates a featured_restaurant" do
      valid_attrs = %{position: 42}

      assert {:ok, %FeaturedRestaurant{} = featured_restaurant} = Profile.create_featured_restaurant(valid_attrs)
      assert featured_restaurant.position == 42
    end

    test "create_featured_restaurant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profile.create_featured_restaurant(@invalid_attrs)
    end

    test "update_featured_restaurant/2 with valid data updates the featured_restaurant" do
      featured_restaurant = featured_restaurant_fixture()
      update_attrs = %{position: 43}

      assert {:ok, %FeaturedRestaurant{} = featured_restaurant} = Profile.update_featured_restaurant(featured_restaurant, update_attrs)
      assert featured_restaurant.position == 43
    end

    test "update_featured_restaurant/2 with invalid data returns error changeset" do
      featured_restaurant = featured_restaurant_fixture()
      assert {:error, %Ecto.Changeset{}} = Profile.update_featured_restaurant(featured_restaurant, @invalid_attrs)
      assert featured_restaurant == Profile.get_featured_restaurant!(featured_restaurant.id)
    end

    test "delete_featured_restaurant/1 deletes the featured_restaurant" do
      featured_restaurant = featured_restaurant_fixture()
      assert {:ok, %FeaturedRestaurant{}} = Profile.delete_featured_restaurant(featured_restaurant)
      assert_raise Ecto.NoResultsError, fn -> Profile.get_featured_restaurant!(featured_restaurant.id) end
    end

    test "change_featured_restaurant/1 returns a featured_restaurant changeset" do
      featured_restaurant = featured_restaurant_fixture()
      assert %Ecto.Changeset{} = Profile.change_featured_restaurant(featured_restaurant)
    end
  end
end
