defmodule ElixirRavelry.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_ravelry,
     aliases: aliases(),
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {ElixirRavelry, []},
     applications: applications(Mix.env)]
  end

  ## Private functions

  defp applications(:test) do
    [:faker | applications(:dev)]
  end

  defp applications(_env) do
    [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                        :phoenix_ecto, :bolt_sips]
  end
  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:bolt_sips, "~> 0.3.2"},
     {:faker, "~> 0.8.0", only: :test}]
  end

  defp aliases() do
    ["compile": "compile --warnings-as-errors"]
  end
end
