defmodule OrderIsComingWeb.Plugs.RequireAdminAuth do
  import Plug.Conn
  import Phoenix.Controller
  use Gettext, otp_app: :order_is_coming

  alias OrderIsComingWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] && conn.assigns.user.admin do
      conn
    else
      conn
      |> put_flash(:error, Gettext.dgettext(OrderIsComingWeb.Gettext, "session", "You must be logged in as admin user"))
      |> redirect(to: Helpers.session_path(conn, :new))
      |> halt() #always use halt to Plugs to tell phoenix to not execute another plug and return the result immediately to user
    end
  end
end
