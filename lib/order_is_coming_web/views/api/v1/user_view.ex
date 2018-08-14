defmodule OrderIsComingWeb.Api.V1.UserView do
  use OrderIsComingWeb, :view

  def render("index.json", %{users: users}) do
    render_many(users, OrderIsComingWeb.Api.V1.UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      username: user.username
    }
  end
end
