defmodule OrderIsComing.Auth.Guardian do
  use Guardian, otp_app: :order_is_coming

  alias OrderIsComing.Accounts

  def subject_for_token(resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.
    case Accounts.get_user!(id) do
      nil -> {:error, :user_not_found}
      resource -> {:ok, resource}
    end
  end
end
