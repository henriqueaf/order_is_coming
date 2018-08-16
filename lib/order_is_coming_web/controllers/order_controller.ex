defmodule OrderIsComingWeb.OrderController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Sales
  alias OrderIsComing.Sales.Order

  plug OrderIsComingWeb.Plugs.RequireAuth
  plug :set_items when action in [:new, :edit, :update, :create]

  def index(conn, _params) do
    orders = Sales.list_orders()
    render(conn, "index.html", orders: orders)
  end

  def new(conn, _params) do
    changeset = Sales.change_order(%Order{ user_id: conn.assigns.user.id, items: [] })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    case Sales.create_order(Map.put(order_params, "user_id", conn.assigns.user.id)) do
      {:ok, order} ->
        Sales.update_order_items(order, order_params["item_ids"])

        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: order_path(conn, :show, order))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Sales.get_order!(id)
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
    order = Sales.get_order!(id)
    changeset = Sales.change_order(order)
    render(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Sales.get_order!(id)

    Sales.update_order_items(order, order_params["item_ids"])

    conn
    |> put_flash(:info, "Order updated successfully.")
    |> redirect(to: order_path(conn, :show, order))
  end

  def update(conn, %{"id" => id}) do
    order = Sales.get_order!(id)

    Sales.update_order_items(order, [])

    conn
    |> put_flash(:info, "Order updated successfully.")
    |> redirect(to: order_path(conn, :show, order))
  end

  def delete(conn, %{"id" => id}) do
    order = Sales.get_order!(id)
    {:ok, _order} = Sales.delete_order(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: order_path(conn, :index))
  end

  defp set_items(conn, _) do
    assign(conn, :items, Sales.list_items)
  end
end
