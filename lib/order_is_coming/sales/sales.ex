require IEx
defmodule OrderIsComing.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias OrderIsComing.Repo

  alias OrderIsComing.Sales.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
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
  def get_item!(id), do: Repo.get!(Item, id) |> Repo.preload(:orders)

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
  Deletes a Item.

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
      %Ecto.Changeset{source: %Item{}}

  """
  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  alias OrderIsComing.Sales.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order) |> Repo.preload([:items, :user])
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id) |> Repo.preload([:items, :user])

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end

  def load_order_value(%Order{} = order) do
    items_sum = Enum.map(order.items, &Decimal.to_float(&1.value))
    |> Enum.sum

    order
    |> Order.changeset(%{ value: items_sum })
    |> Repo.update
  end

  alias OrderIsComing.Sales.ItemOrder

  def update_order_items(%Order{} = order, item_ids) when is_list item_ids do
    ItemOrder
    |> where([io], io.order_id == ^order.id)
    |> where([io], not(io.item_id in ^item_ids))
    |> Repo.delete_all

    Enum.each(item_ids, fn(item_id) ->
      case get_item_order_by(%{item_id: item_id, order_id: order.id}) do
        nil ->
          create_item_order(item_id, order.id)
        _ -> nil
      end
    end)

    reloaded_order = get_order!(order.id)
    load_order_value(reloaded_order)
  end

  def update_order_items(%Order{} = order, _) do
    ItemOrder
    |> where([io], io.order_id == ^order.id)
    |> Repo.delete_all

    order
    |> Order.changeset(%{value: 0})
    |> Repo.update()
  end

  def create_item_order(item_id, order_id) do
    ItemOrder.changeset(%ItemOrder{}, %{item_id: item_id, order_id: order_id})
    |> Repo.insert()
  end

  def get_item_order_by(map) do
    Repo.get_by(ItemOrder, map)
  end
end
