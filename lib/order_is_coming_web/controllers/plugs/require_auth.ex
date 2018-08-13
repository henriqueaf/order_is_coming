defmodule OrderIsComingWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias OrderIsComingWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.session_path(conn, :new))
      |> halt() #always use halt to Plugs to tell phoenix to not execute another plug and return the result immediately to user
    end
  end
end
