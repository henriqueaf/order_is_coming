defmodule OrderIsComingWeb.ItemController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Sales
  alias OrderIsComing.Sales.Item

  plug OrderIsComingWeb.Plugs.RequireAuth
  plug :format_value when action in [:create, :update]

  def index(conn, _params) do
    items = Sales.list_items()
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Sales.change_item(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Sales.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: item_path(conn, :show, item))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Sales.get_item!(id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Sales.get_item!(id)
    changeset = Sales.change_item(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Sales.get_item!(id)

    case Sales.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: item_path(conn, :show, item))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Sales.get_item!(id)
    {:ok, _item} = Sales.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: item_path(conn, :index))
  end

  defp format_value(%{params: %{"item" => %{"value" => unformated_value}}} = conn, _) do
    if unformated_value do
      formated_value = String.replace(unformated_value, ",", ".")
      update_in(conn.params["item"], fn(item_params) ->
        Map.put(item_params, "value", formated_value)
      end)
    else
      conn
    end
  end
end
