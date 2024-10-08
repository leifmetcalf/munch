defmodule MunchWeb.ItemLiveTest do
  use MunchWeb.ConnCase

  import Phoenix.LiveViewTest
  import Munch.ListsFixtures

  @create_attrs %{position: 42}
  @update_attrs %{position: 43}
  @invalid_attrs %{position: nil}

  defp create_item(_) do
    item = item_fixture()
    %{item: item}
  end

  describe "Index" do
    setup [:create_item]

    test "lists all list_items", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/list_items")

      assert html =~ "Listing List items"
    end

    test "saves new item", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/list_items")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Item")
               |> render_click()
               |> follow_redirect(conn, ~p"/list_items/new")

      assert render(form_live) =~ "New Item"

      assert form_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#item-form", item: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/list_items")

      html = render(index_live)
      assert html =~ "Item created successfully"
    end

    test "updates item in listing", %{conn: conn, item: item} do
      {:ok, index_live, _html} = live(conn, ~p"/list_items")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#list_items-#{item.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/list_items/#{item}/edit")

      assert render(form_live) =~ "Edit Item"

      assert form_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#item-form", item: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/list_items")

      html = render(index_live)
      assert html =~ "Item updated successfully"
    end

    test "deletes item in listing", %{conn: conn, item: item} do
      {:ok, index_live, _html} = live(conn, ~p"/list_items")

      assert index_live |> element("#list_items-#{item.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#list_items-#{item.id}")
    end
  end

  describe "Show" do
    setup [:create_item]

    test "displays item", %{conn: conn, item: item} do
      {:ok, _show_live, html} = live(conn, ~p"/list_items/#{item}")

      assert html =~ "Show Item"
    end

    test "updates item and returns to show", %{conn: conn, item: item} do
      {:ok, show_live, _html} = live(conn, ~p"/list_items/#{item}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/list_items/#{item}/edit?return_to=show")

      assert render(form_live) =~ "Edit Item"

      assert form_live
             |> form("#item-form", item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#item-form", item: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/list_items/#{item}")

      html = render(show_live)
      assert html =~ "Item updated successfully"
    end
  end
end
