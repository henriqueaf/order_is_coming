defmodule OrderIsComing.Accounts.Encryption do
  alias Comeonin.Bcrypt

  def hash_password(password), do: Bcrypt.hashpwsalt(password)
  def validate_password(password, hash), do: Bcrypt.checkpw(password, hash)
end
