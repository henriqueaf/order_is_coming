defmodule OrderIsComingWeb.SessionController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Repo
  alias OrderIsComing.Accounts.Auth

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, params) do
    case Auth.login(params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Logged In")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:error, "Incorrect username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: session_path(conn, :new))
  end
end
