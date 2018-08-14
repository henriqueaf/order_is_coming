defmodule OrderIsComingWeb.Api.V1.UserControllerTest do
  use OrderIsComingWeb.ConnCase
  import OrderIsComing.Auth.Guardian

  alias OrderIsComing.Accounts

  @create_attrs %{name: "some name", password: "some password", username: "some username"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    setup [:create_user]

    test "lists all users", %{conn: conn, user: user} do
      {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

      conn = conn
      |> put_req_header("authorization", "Bearer: " <> token)
      |> get(api_v1_user_path(conn, :index))

      # body = json_response(conn, 200)
      # assert user.username in body
      assert json_response(conn, 200) == render_json("index.json", users: [user])
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp render_json(template, assigns) do
    assigns = Map.new(assigns)

    OrderIsComingWeb.Api.V1.UserView.render(template, assigns)
    |> Poison.encode!
    |> Poison.decode!
  end
end
