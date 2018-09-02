defmodule OrderIsComingWeb.ItemControllerTest do
  import Plug.Test
  use OrderIsComingWeb.ConnCase

  alias OrderIsComing.Sales
  alias OrderIsComing.Accounts

  @create_user_attrs %{name: "some name", password: "some password", username: "some username", admin: true}
  @create_attrs %{code: 42, description: "some description", name: "some name", value: "120.5"}
  @update_attrs %{code: 43, description: "some updated description", name: "some updated name", value: "456.7"}
  @invalid_attrs %{code: nil, description: nil, name: nil, value: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_user_attrs)
    user
  end

  def fixture(:item) do
    {:ok, item} = Sales.create_item(@create_attrs)
    item
  end

  setup do
    item = fixture(:item)
    user = fixture(:user)
    {:ok, user: user, item: item}
  end

  describe "index" do
    test "lists all items", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> get(item_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Items"
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> get(item_path(conn, :new))
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> post(item_path(conn, :create), item: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == item_path(conn, :show, id)

      conn = get conn, item_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Item"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> post(item_path(conn, :create), item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "edit item" do
    test "renders form for editing chosen item", %{conn: conn, item: item, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> get(item_path(conn, :edit, item))
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "update item" do
    test "redirects when data is valid", %{conn: conn, item: item, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> put(item_path(conn, :update, item), item: @update_attrs)
      assert redirected_to(conn) == item_path(conn, :show, item)

      conn = get conn, item_path(conn, :show, item)
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, item: item, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> put(item_path(conn, :update, item), item: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Item"
    end
  end

  describe "delete item" do
    test "deletes chosen item", %{conn: conn, item: item, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> delete(item_path(conn, :delete, item))
      assert redirected_to(conn) == item_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, item_path(conn, :show, item)
      end
    end
  end
end
