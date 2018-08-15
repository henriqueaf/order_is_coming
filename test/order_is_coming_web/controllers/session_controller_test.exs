defmodule OrderIsComingWeb.SessionControllerTest do
  use OrderIsComingWeb.ConnCase

  alias OrderIsComing.Accounts

  @create_attrs %{name: "some name", password: "some password_hash", username: "some username"}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "new" do
    test "render sessions new template", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "create" do
    setup [:create_user]

    test "should save user in session", %{conn: conn, user: user} do
      conn = post conn, session_path(conn, :create), [username: user.username, password: user.password]

      assert redirected_to(conn, 302) =~ page_path(conn, :index)
      assert get_flash(conn, :info) =~ "Logged In"

      %Plug.Conn{private: %{ plug_session: %{ "user_id" => session_user_id } } } = conn
      assert session_user_id == user.id
    end

    test "should not save user in session with wrong credentials", %{conn: conn} do
      conn = post conn, session_path(conn, :create), [username: "wrong", password: "wrong"]

      assert html_response(conn, 200) =~ "Login"
      assert get_flash(conn, :error) =~ "Incorrect username or password"

      %Plug.Conn{private: %{ plug_session: session } } = conn
      refute Map.has_key?(session, "user_id")
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
