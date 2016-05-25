defmodule Pinboardixir.Mixfile do
  use Mix.Project

  def project do
    [app: :pinboardixir,
     version: "0.0.1",
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
     {:poison, "~> 2.0"}]
  end

  defp package do
    [
      name: :pinboardixir,
      maintainers: ["Lou Xun"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/ElaWorkshop/pinboardixir"
      }
    ]
  end
end
