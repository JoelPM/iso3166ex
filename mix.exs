defmodule ISO3166.Mixfile do
  use Mix.Project

  def project do
    [app: :iso3166,
     version: "0.0.5",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  defp description do
    """
    A library that provides a list of ISO3166 country names,
    two letter abbreviations, three letter abbreviations, and
    functions for converting between them.
    """
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    case Mix.env == :dev do
      true -> [applications: [:exsync]]
      false -> []
    end
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
      { :poison, "~> 2.1"             },
      { :floki,  "~> 0.7"             },
      { :ex_csv, "~> 0.1.4"           },
      { :exsync, "~> 0.1", only: :dev }
    ]
  end

  defp package do
    [
      maintainers: ["joel.meyer@gmail.com"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joelpm/iso3166ex"}
    ]
  end
end
