defmodule OrderIsComingWeb.UserView do
  use OrderIsComingWeb, :view

  def handler_admin_info(user) do
    case user.admin do
      true ->
        raw "<span class=\"badge badge-success\">#{gettext("yes")}</span>"
      false ->
        raw "<span class=\"badge badge-danger\">#{gettext("no")}</span>"
    end
  end
end
