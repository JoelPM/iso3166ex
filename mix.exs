defmodule ISO3166.Mixfile do
  use Mix.Project

  def project do
    [app: :iso3166,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    dev_apps = Mix.env == :dev && [:exsync] || []
    [applications: dev_apps ++ [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 1.5"},
      {:floki, "~> 0.7"},
      {:exsync, "~> 0.1", only: :dev}
    ]
  end
end
