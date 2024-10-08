defmodule Munch.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Munch.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Munch.Lists.create_list()

    list
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        position: 42
      })
      |> Munch.Lists.create_item()

    item
  end
end
