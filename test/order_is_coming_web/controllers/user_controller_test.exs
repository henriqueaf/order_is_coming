defmodule OrderIsComingWeb.UserControllerTest do
  import Plug.Test
  use OrderIsComingWeb.ConnCase

  alias OrderIsComing.Accounts

  @create_attrs %{name: "some name", password: "some password", username: "some username"}
  @update_attrs %{name: "some updated name", password: "some updated password", username: "some updated username"}
  @invalid_attrs %{name: nil, password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup do
    user = fixture(:user)
    {:ok, user: user}
  end

  describe "index" do
    test "lists all users", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> get(user_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> get(user_path(conn, :new))

      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> post(user_path(conn, :create), user: %{@create_attrs | username: "other_user"})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> post(user_path(conn, :create), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> get(user_path(conn, :edit, user))

      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> put(user_path(conn, :update, user), user: @update_attrs)

      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = conn
      |> get(user_path(conn, :show, user))

      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn
      |> init_test_session(user_id: user.id)
      |> put(user_path(conn, :update, user), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conn: conn, user: user} do
      {:ok, other_user} = Accounts.create_user(%{@create_attrs | username: "other_user"})

      conn = conn
      |> init_test_session(user_id: user.id)
      |> delete(user_path(conn, :delete, other_user))

      assert redirected_to(conn) == user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, other_user)
      end
    end
  end
end
