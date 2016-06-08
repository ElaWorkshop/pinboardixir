defmodule Pinboardixir.Client do
  @moduledoc false
  use HTTPoison.Base

  @typedoc """
  Refer to [Pinboard's official documentation](https://pinboard.in/api/) for explaination and example. Note:

  - All values should be String, booleans are represented by "yes" or "no"
  - To represent multiple tags, seperate them by space or `,`
  - Invalid keys will be filtered out before sending the request
  """
  @type options :: [{atom, String.t}]

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
