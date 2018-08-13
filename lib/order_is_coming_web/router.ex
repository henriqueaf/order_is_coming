defmodule OrderIsComingWeb.Router do
  use OrderIsComingWeb, :router

  alias OrderIsComingWeb.Router.Helpers

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OrderIsComingWeb.Plugs.SetUser
    plug :set_user_token_for_websocket
    # plug :redirect_not_logged_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OrderIsComingWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", OrderIsComingWeb do
  #   pipe_through :api
  # end

  defp set_user_token_for_websocket(conn, _) do
    if current_user = conn.assigns.user do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  # defp redirect_not_logged_user(conn, _) do
  #   current_user = conn.assigns.user
  #   "/" <> request_path = conn.request_path

  #   if current_user == nil and request_path !== "login" && request_path !== "logout" do
  #     conn
  #     |> put_flash(:error, "You must be logged in")
  #     |> redirect(to: Helpers.session_path(conn, :new))
  #     |> halt()
  #   else
  #     conn
  #   end
  # end
end
