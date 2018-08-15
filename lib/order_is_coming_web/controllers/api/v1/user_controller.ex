defmodule OrderIsComingWeb.Api.V1.UserController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end
end
