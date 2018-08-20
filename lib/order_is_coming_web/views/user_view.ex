defmodule OrderIsComingWeb.UserView do
  use OrderIsComingWeb, :view

  def handler_admin_info(user) do
    case user.admin do
      true ->
        raw "<span class=\"badge badge-success\">Yes</span>"
      false ->
        raw "<span class=\"badge badge-danger\">No</span>"
    end
  end
end
