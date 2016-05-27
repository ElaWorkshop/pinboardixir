defmodule Pinboardixir.Mixfile do
  use Mix.Project

  def project do
    [app: :pinboardixir,
     version: "0.0.3",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp description do
    "A Pinboard client in Elixir."
  end

  defp deps do
    [{:httpoison, "~> 0.8"},
     {:poison, "~> 2.0"},
     {:ex_doc, "~> 0.11", only: :dev},
     {:earmark, "~> 0.1", only: :dev},
     {:credo, "~> 0.4.0-beta2", only: :dev},
     {:dialyxir, "~> 0.3", only: :dev},
     {:inch_ex, ">= 0.0.0", only: :docs},
     {:bypass, "~> 0.5", only: :test}]
  end

  defp package do
    [
      name: :pinboardixir,
      maintainers: ["Lou Xun <aquarhead@ela.build>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/ElaWorkshop/pinboardixir"
      }
    ]
  end
end
