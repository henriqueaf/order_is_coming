defmodule OrderIsComingWeb.Api.V1.SessionView do
  use OrderIsComingWeb, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
