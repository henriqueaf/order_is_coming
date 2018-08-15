defmodule OrderIsComingWeb.Api.V1.SessionController do
  use OrderIsComingWeb, :controller

  alias OrderIsComing.Accounts.Auth

  def sign_in(conn, params) do
    case Auth.login(params) do
      {:ok, user} ->
        with {:ok, token, _claims} <- OrderIsComing.Auth.Guardian.encode_and_sign(user) do
          render conn, "token.json", token: token
        end
      :error ->
        body = Poison.encode!(%{error: "Incorrect username or password"})
        conn
        |> send_resp(401, body)
    end
  end
end
