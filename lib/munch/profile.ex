defmodule Munch.Profile do
  @moduledoc """
  The Profile context.
  """

  import Ecto.Query, warn: false
  alias Munch.Repo

  alias Munch.Profile.FeaturedRestaurant

  @doc """
  Returns the list of featured_restaurants for a user.

  ## Examples

      iex> list_featured_restaurants(user)
      [%FeaturedRestaurant{}, ...]

  """
  def list_featured_restaurants(user) do
    Repo.all(
      from(fr in FeaturedRestaurant, where: fr.user_id == ^user.id, order_by: [asc: fr.position])
    )
  end

  @doc """
  Gets a single featured_restaurant.

  Raises `Ecto.NoResultsError` if the Featured restaurant does not exist.

  ## Examples

      iex> get_featured_restaurant!(123)
      %FeaturedRestaurant{}

      iex> get_featured_restaurant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_featured_restaurant!(id), do: Repo.get!(FeaturedRestaurant, id)

  @doc """
  Creates a featured_restaurant.

  ## Examples

      iex> create_featured_restaurant(%{field: value})
      {:ok, %FeaturedRestaurant{}}

      iex> create_featured_restaurant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_featured_restaurant(user, attrs \\ %{}) do
    %FeaturedRestaurant{user_id: user.id}
    |> FeaturedRestaurant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a featured_restaurant.

  ## Examples

      iex> update_featured_restaurant(featured_restaurant, %{field: new_value})
      {:ok, %FeaturedRestaurant{}}

      iex> update_featured_restaurant(featured_restaurant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_featured_restaurant(user, %FeaturedRestaurant{} = featured_restaurant, attrs) do
    if featured_restaurant.user_id == user.id do
      featured_restaurant
      |> FeaturedRestaurant.changeset(attrs)
      |> Repo.update()
    else
      {:error, Munch.NotAuthorizedError}
    end
  end

  @doc """
  Deletes a featured_restaurant.

  ## Examples

      iex> delete_featured_restaurant(featured_restaurant)
      {:ok, %FeaturedRestaurant{}}

      iex> delete_featured_restaurant(featured_restaurant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_featured_restaurant(user, %FeaturedRestaurant{} = featured_restaurant) do
    if featured_restaurant.user_id == user.id do
      Repo.delete(featured_restaurant)
    else
      {:error, Munch.NotAuthorizedError}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking featured_restaurant changes.

  ## Examples

      iex> change_featured_restaurant(featured_restaurant)
      %Ecto.Changeset{data: %FeaturedRestaurant{}}

  """
  def change_featured_restaurant(%FeaturedRestaurant{} = featured_restaurant, attrs \\ %{}) do
    FeaturedRestaurant.changeset(featured_restaurant, attrs)
  end
end
