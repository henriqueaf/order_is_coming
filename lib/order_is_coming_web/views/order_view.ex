defmodule OrderIsComingWeb.OrderView do
  use OrderIsComingWeb, :view

  def render("order.json", %{order: order}) do
    %{
      id: order.id
    }
  end

  def render("order.html", %{order: order, conn: conn}) do
    edit_link = link dgettext("links", "Edit"), to: order_path(conn, :edit, order), class: "btn btn-default btn-xs"
    delete_link = link dgettext("links", "Delete"), to: order_path(conn, :delete, order), method: :delete, data: [confirm: gettext("Are you sure?")], class: "btn btn-danger btn-xs"

    raw """
    <tr data-id=#{order.id}>
      <td>#{order.value}</td>
      <td>#{Enum.map_join(order.items, ",", &(&1.name))}</td>
      <td>#{order.user.name}</td>

      <td class="text-right">
        <span>#{safe_to_string edit_link}</span>
        <span>#{safe_to_string delete_link}</span>
      </td>
    </tr>
    """
  end
end
