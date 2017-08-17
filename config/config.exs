# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :elixir_ravelry,
  ecto_repos: [ElixirRavelry.Repo]

# Configures the endpoint
config :elixir_ravelry, ElixirRavelryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dvTE2Cv3KfNB1s7PriMjMB7eHCPF+1O1+7l3QUs1Y8SqUrwBQmJrzkQrqBzALTzt",
  render_errors: [view: ElixirRavelryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirRavelryWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Bolt Sips - Neo4j w/ Elixir
config :bolt_sips, Bolt,
      url: "localhost:7687",
      basic_auth: [username: "neo4j", password: "Trogdor4$"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
