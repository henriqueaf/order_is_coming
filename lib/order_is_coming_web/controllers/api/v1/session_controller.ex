defmodule OrderIsComingWeb.Api.V1.SessionController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Accounts.Auth

  def sign_in(conn, params) do
    case Auth.login(params) do
      {:ok, user} ->
        with {:ok, token, _claims} <- OrderIsComing.Auth.Guardian.encode_and_sign(user) do
          # Render the token
          render conn, "token.json", token: token
        end
      :error ->
        conn
        |> send_resp(401, "Incorrect username or password")
    end
  end
end
