defmodule OrderIsComing.Accounts.Auth do
  alias OrderIsComing.Accounts.Encryption

  def login(%{"username" => username, "password" => password}) do
    user = OrderIsComing.Accounts.get_user_by( %{username: username} )

    case authenticate(user, password) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def login(_), do: :error

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Encryption.validate_password(password, user.password_hash)
    end
  end
end
