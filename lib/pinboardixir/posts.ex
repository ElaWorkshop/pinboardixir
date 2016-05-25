defmodule Pinboardixir.Post do
  defstruct(
    href: "",
    description: "",
    extended: "",
    meta: "",
    hash: "",
    time: "",
    shared: false,
    toread: false,
    tags: []
  )
end

defmodule Pinboardixir.Posts do
  use HTTPoison.Base

  alias Pinboardixir.Post

  @token_and_json "auth_token=#{Application.get_env(:pinboardixir, :auth_token)}&format=json"

  @doc ~S"""
  Use base_endpoint and "/posts" to compose full URL, and add auth_token.
  """
  def process_url(url) do
    request_url = Application.get_env(:pinboardixir, :base_endpoint) <> "/posts" <> url
    if String.contains?(request_url, "?") do
      request_url <> "&" <> @token_and_json
    else
      request_url <> "?" <> @token_and_json
    end
  end

  @doc """
  Get all bookmarks in the user's account.
  """
  def all() do
    get!("/all").body
    |> Poison.decode!(as: [%Post{}])
  end

end
