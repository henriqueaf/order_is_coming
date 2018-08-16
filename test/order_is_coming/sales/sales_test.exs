defmodule OrderIsComing.SalesTest do
  use OrderIsComing.DataCase

  alias OrderIsComing.Sales

  describe "items" do
    alias OrderIsComing.Sales.Item

    @valid_attrs %{code: 42, description: "some description", name: "some name", value: "120.5"}
    @update_attrs %{code: 43, description: "some updated description", name: "some updated name", value: "456.7"}
    @invalid_attrs %{code: nil, description: nil, name: nil, value: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sales.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Sales.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Sales.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Sales.create_item(@valid_attrs)
      assert item.code == 42
      assert item.description == "some description"
      assert item.name == "some name"
      assert item.value == Decimal.new("120.5")
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = Sales.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.code == 43
      assert item.description == "some updated description"
      assert item.name == "some updated name"
      assert item.value == Decimal.new("456.7")
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_item(item, @invalid_attrs)
      assert item == Sales.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Sales.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Sales.change_item(item)
    end
  end

  describe "orders" do
    alias OrderIsComing.Sales.Order

    @valid_attrs %{value: "120.5"}
    @update_attrs %{value: "456.7"}
    @invalid_attrs %{value: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sales.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Sales.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Sales.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Sales.create_order(@valid_attrs)
      assert order.value == Decimal.new("120.5")
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = Sales.update_order(order, @update_attrs)
      assert %Order{} = order
      assert order.value == Decimal.new("456.7")
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_order(order, @invalid_attrs)
      assert order == Sales.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Sales.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Sales.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Sales.change_order(order)
    end
  end
end
