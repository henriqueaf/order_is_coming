defmodule OrderIsComing.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :phoenix_authentication,
    error_handler: OrderIsComing.Auth.ErrorHandler,
    module: OrderIsComing.Auth.Guardian

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
