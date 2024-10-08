defmodule Munch.ListsTest do
  use Munch.DataCase

  alias Munch.Lists

  describe "lists" do
    alias Munch.Lists.List

    import Munch.ListsFixtures

    @invalid_attrs %{name: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %List{} = list} = Lists.create_list(valid_attrs)
      assert list.name == "some name"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.name == "some updated name"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_list(list, @invalid_attrs)
      assert list == Lists.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Lists.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Lists.change_list(list)
    end
  end

  describe "list_items" do
    alias Munch.Lists.Item

    import Munch.ListsFixtures

    @invalid_attrs %{position: nil}

    test "list_list_items/0 returns all list_items" do
      item = item_fixture()
      assert Lists.list_list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Lists.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{position: 42}

      assert {:ok, %Item{} = item} = Lists.create_item(valid_attrs)
      assert item.position == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lists.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{position: 43}

      assert {:ok, %Item{} = item} = Lists.update_item(item, update_attrs)
      assert item.position == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Lists.update_item(item, @invalid_attrs)
      assert item == Lists.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Lists.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Lists.change_item(item)
    end
  end
end
