use Mix.Config

config :pinboardixir,
  base_endpoint: "https://api.pinboard.in/v1",
  auth_token: System.get_env("PINBOARD_TOKEN")
