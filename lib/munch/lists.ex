defmodule Munch.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias Munch.Repo

  alias Munch.Lists.List
  alias Munch.Lists.Item

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists do
    Repo.all(
      from l in List,
        as: :lists,
        select: %{
          l
          | length:
              subquery(from i in Item, where: i.list_id == parent_as(:lists).id, select: count(i))
        }
    )
  end

  def user_lists(user) do
    Repo.all(
      from l in List,
        as: :lists,
        where: l.user_id == ^user.id,
        select: %{
          l
          | length:
              subquery(from i in Item, where: i.list_id == parent_as(:lists).id, select: count(i))
        }
    )
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id) do
    Repo.get!(List, id)
    |> Repo.preload(items: [:restaurant])
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(user, attrs \\ %{}) do
    %List{user_id: user.id}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(user, %List{} = list, attrs) do
    if list.user_id == user.id do
      list
      |> List.changeset(attrs)
      |> Repo.update()
    else
      raise Munch.NotAuthorizedError
    end
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(user, %List{} = list) do
    if list.user_id == user.id do
      Repo.delete(list)
    else
      raise Munch.NotAuthorizedError
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  @doc """
  Creates a changeset and prepends a restaurant to the list items.
  """
  def changeset_prepend_restaurant(changeset, restaurant_id) do
    List.prepend_restaurant(changeset, restaurant_id)
  end

  alias Munch.Lists.Item

  @doc """
  Returns the list of list_items.

  ## Examples

      iex> list_list_items()
      [%Item{}, ...]

  """
  def list_list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id) do
    Repo.get!(Item, id) |> Repo.preload(:restaurant)
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
