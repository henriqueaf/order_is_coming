defmodule OrderIsComingWeb.PageController do
  use OrderIsComingWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
