defmodule OrderIsComingWeb.Api.V1.UserController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Accounts

  def index(conn, _params) do
    with resource <- OrderIsComing.Auth.Guardian.Plug.current_resource(conn) do
      IO.puts "==============================="
      IO.inspect resource
    end

    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end
end
