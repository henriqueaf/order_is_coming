defmodule OrderIsComing.Accounts.Auth do
  alias OrderIsComing.Accounts.{Encryption, User}

  def login(params, repo) do
    user = repo.get_by(User, username: String.downcase(params["username"]))

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
