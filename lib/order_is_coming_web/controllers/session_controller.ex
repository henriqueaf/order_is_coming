defmodule OrderIsComingWeb.SessionController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Accounts.Auth

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, params) do
    case Auth.login(params) do
      {:ok, user} ->
        case user.admin do
          true ->
            conn
            |> put_session(:user_id, user.id)
            |> redirect(to: "/")
          false ->
            conn
            |> put_flash(:error, dgettext("session", "You must be a admin user"))
            |> render("new.html")
        end
      :error ->
        conn
        |> put_flash(:error, dgettext("session", "Incorrect username or password"))
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: session_path(conn, :new))
  end
end
