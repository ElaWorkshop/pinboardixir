defmodule Pinboardixir.Post do
  @moduledoc false

  @doc """
  """
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
  @moduledoc """
  Endpoints under "/posts".
  """
  alias Pinboardixir.Client

  import Pinboardixir.Utils

  alias Pinboardixir.Post

  @valid_all_options [:tag, :start, :results, :fromdt, :todt, :meta, :toread]

  @doc """
  Get all bookmarks in the user's account.

  Also, `:toread` can be used to filter posts marked as "read later".
  """
  @spec all(Client.options) :: [Post.t]
  def all(options \\ nil) do
    url = "/posts/all" <> build_params(options, @valid_all_options)
    Client.get!(url).body
    |> Poison.decode!(as: [%Post{}])
  end

  @valid_get_options [:tag, :dt, :url, :meta]

  @doc """
  Get one or more posts on a single day matching the arguments. If no date or url is given, date of most recent bookmark will be used.
  """
  @spec get(Client.options) :: [Post.t]
  def get(options \\ nil) do
    url = "/posts/get" <> build_params(options, @valid_get_options)
    Client.get!(url).body
    |> Poison.decode!(as: %{"posts" => [%Post{}]})
    |> Map.get("posts")
  end
end
