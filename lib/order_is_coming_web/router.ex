defmodule OrderIsComingWeb.Router do
  use OrderIsComingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OrderIsComingWeb.Plugs.SetUser
    plug :set_user_token_for_websocket
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug OrderIsComing.Auth.Pipeline
  end

  scope "/", OrderIsComingWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    resources "/users", UserController
  end

  scope "/api", OrderIsComingWeb, as: :api do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      post "/sign_in", SessionController, :sign_in

      pipe_through :api_auth
      resources "/users", UserController, only: [:index]
    end
  end

  defp set_user_token_for_websocket(conn, _) do
    if current_user = conn.assigns.user do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
