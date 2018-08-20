# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :order_is_coming,
  ecto_repos: [OrderIsComing.Repo]

# Configures the endpoint
config :order_is_coming, OrderIsComingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s4lE6uFytXJzZV8IptWmOWSmNuzNaCJGlU0p3DunP5L8p5pvOAidqUuLxKw7do52",
  render_errors: [view: OrderIsComingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OrderIsComing.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :order_is_coming, OrderIsComing.Auth.Guardian,
  issuer: "order_is_coming",
  secret_key: "jMhHyjDodMO69doj2zlJdHYgoUgoDkiN2p3iT81KJwtTF2rzebMRcVDpAEqiEf/k"

# Configures the default locale of GetText
config :order_is_coming, OrderIsComingWeb.Gettext, default_locale: "pt_BR", locales: ~w(en pt_BR)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
