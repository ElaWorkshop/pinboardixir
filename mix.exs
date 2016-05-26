defmodule Pinboardixir.Mixfile do
  use Mix.Project

  def project do
    [app: :pinboardixir,
     version: "0.0.2",
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
     {:earmark, "~> 0.1", only: :dev}]
  end

  defp package do
    [
      name: :pinboardixir,
      maintainers: ["Lou Xun <aquarhead@gmail.com>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/ElaWorkshop/pinboardixir"
      }
    ]
  end
end
