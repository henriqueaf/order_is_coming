defmodule OrderIsComingWeb.Api.V1.SessionControllerTest do
  use OrderIsComingWeb.ConnCase

  alias OrderIsComing.Accounts

  @create_attrs %{name: "some name", password: "some password", username: "some username"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "sign_in" do
    setup [:create_user]

    test "return user token", %{conn: conn, user: user} do
      conn = post conn, api_v1_session_path(conn, :sign_in), [username: user.username, password: user.password]

      response = json_response(conn, 200)
      assert response_content_type(conn, :json)
      assert Map.has_key?(response, "token")
    end
  end

  def create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
