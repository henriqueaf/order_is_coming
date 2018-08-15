defmodule OrderIsComing.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias OrderIsComing.Accounts.Encryption

  schema "users" do
    field :name, :string
    field :password_hash, :string
    field :username, :string
    ## VIRTUAL FIELDS ##
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(name username password)a
  @optional_fields ~w()a

  @update_required_fields ~w(name username)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 4)
    |> validate_confirmation(:password)
    |> unique_constraint(:username, downcase: true)
    |> encrypt_password()
    |> validate_required(:password_hash)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @update_required_fields, @optional_fields)
    |> validate_required(@update_required_fields)
    |> validate_length(:password, min: 4)
    |> validate_confirmation(:password)
    |> unique_constraint(:username, downcase: true)
    |> encrypt_password()
    |> validate_required(:password_hash)
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :password_hash, encrypted_password)
    else
      changeset
    end
  end
end
