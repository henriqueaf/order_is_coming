defmodule OrderIsComingWeb.OrdersChannel do
  use OrderIsComingWeb, :channel

  def join("orders:index", _auth_msg, socket) do
    {:ok, %{}, socket}
  end
end
