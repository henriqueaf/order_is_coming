defmodule OrderIsComingWeb.OrderController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Sales
  alias OrderIsComing.Sales.Order

  plug OrderIsComingWeb.Plugs.RequireAdminAuth
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
        {:ok, reloaded_order} = Sales.update_order_items(order, order_params["item_ids"])

        order_string_template = Phoenix.View.render_to_string(OrderIsComingWeb.OrderView, "order.html", order: reloaded_order, conn: conn)
        OrderIsComingWeb.Endpoint.broadcast!("orders:index", "new_order", %{order: order_string_template})
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: order_path(conn, :index))
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

    update_order(order, order_params["item_ids"], conn)

    conn
    |> put_flash(:info, "Order updated successfully.")
    |> redirect(to: order_path(conn, :index))
  end

  def update(conn, %{"id" => id}) do
    order = Sales.get_order!(id)

    update_order(order, [], conn)

    conn
    |> put_flash(:info, "Order updated successfully.")
    |> redirect(to: order_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    order = Sales.get_order!(id)
    {:ok, _order} = Sales.delete_order(order)

    OrderIsComingWeb.Endpoint.broadcast!("orders:index", "delete_order", %{order_id: order.id})

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: order_path(conn, :index))
  end

  defp set_items(conn, _) do
    assign(conn, :items, Sales.list_items)
  end

  defp update_order(order, item_ids, conn) do
    {:ok, reloaded_order} = Sales.update_order_items(order, item_ids)
    order_string_template = Phoenix.View.render_to_string(OrderIsComingWeb.OrderView, "order.html", order: reloaded_order, conn: conn)
    OrderIsComingWeb.Endpoint.broadcast!("orders:index", "update_order", %{order_id: order.id, order: order_string_template })
  end
end
