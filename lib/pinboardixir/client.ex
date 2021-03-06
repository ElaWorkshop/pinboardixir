defmodule Pinboardixir.Client do
  @moduledoc false
  use HTTPoison.Base

  @token_and_json "auth_token=#{Application.get_env(:pinboardixir, :auth_token)}&format=json"

  # Use base_endpoint to compose full URL, then add auth_token.
  defp process_url(url) do
    request_url = Application.get_env(:pinboardixir, :base_endpoint) <> url
    if String.contains?(request_url, "?") do
      request_url <> "&" <> @token_and_json
    else
      request_url <> "?" <> @token_and_json
    end
  end
end
