defmodule OrderIsComing.Accounts.Auth do
  alias OrderIsComing.Accounts.Encryption

  def login(params) do
    user = OrderIsComing.Accounts.get_user_by( %{username: String.downcase(params["username"])} )

    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Encryption.validate_password(password, user.password_hash)
    end
  end
end
