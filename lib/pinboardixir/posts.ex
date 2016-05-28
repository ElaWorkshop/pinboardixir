defmodule Pinboardixir.Post do
  @moduledoc false

  @doc """
  As described in Pinboard's API documentation, `description` is title and `extended` is description.
  """
  defstruct [
    :href,
    :description,
    :extended,
    :meta,
    :hash,
    :time,
    :shared,
    :toread,
    :tags,
  ]
end

defmodule Pinboardixir.Posts do
  @moduledoc """
  Endpoints under "/posts".
  """
  import Pinboardixir.Utils

  alias Pinboardixir.Client
  alias Pinboardixir.Post

  @doc """
  Returns the most recent time a bookmark was added, updated or deleted.

  Use this before calling posts/all to see if the data has changed since the last fetch.
  """
  @spec update() :: String.t # TODO: make this into DateTime after Elixir 1.3
  def update do
    Client.get!("/posts/update").body
    |> Poison.decode!
    |> Map.get("update_time")
  end

  @valid_all_options [:tag, :start, :results, :fromdt, :todt, :meta, :toread]

  @doc """
  Get all bookmarks in the user's account.

  Also, `:toread` can be used to filter posts marked as "read later".
  """
  @spec all(Client.options) :: [Post.t]
  def all(options \\ []) do
    url = "/posts/all" <> build_params(options, @valid_all_options)
    Client.get!(url).body
    |> Poison.decode!(as: [%Post{}])
  end

  @valid_get_options [:tag, :dt, :url, :meta]

  @doc """
  Get one or more posts on a single day matching the arguments.
  """
  @spec get(Client.options) :: [Post.t]
  def get(options \\ []) do
    url = "/posts/get" <> build_params(options, @valid_get_options)
    Client.get!(url).body
    |> Poison.decode!(as: %{"posts" => [%Post{}]})
    |> Map.get("posts")
  end

  @valid_add_options [:url, :description, :extended,
                      :tags, :dt, :replace, :shared, :toread]

  @doc """
  Add a bookmark.
  """
  @spec add(String.t, String.t, Client.options) :: String.t
  def add(url, description, options \\ []) do
    request_url = "/posts/add" <> (
      [url: url, description: description]
      |> Keyword.merge(options)
      |> build_params(@valid_add_options)
    )

    Client.get!(request_url).body
    |> Poison.decode!
    |> Map.get("result_code")
  end

  @doc """
  Delete a bookmark.
  """
  @spec delete(String.t) :: String.t
  def delete(url) do
    request_url = "/posts/delete" <> build_params([url: url], [:url])

    Client.get!(request_url).body
    |> Poison.decode!
    |> Map.get("result_code")
  end

  @doc """
  Returns a list of dates with the number of posts at each date.
  """
  @spec dates(Client.options) :: %{String.t => integer}
  def dates(options \\ []) do
    request_url = "/posts/dates" <> build_params(options, [:tag])
    Client.get!(request_url).body
    |> Poison.decode!
    |> Map.get("dates")
    |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
    |> Enum.into(Map.new)
  end

  @doc """
  Returns a list of the user's most recent posts.
  """
  @spec recent(Client.options) :: [%Post{}]
  def recent(options \\ []) do
    request_url = "/posts/recent" <> build_params(options, [:tag, :count])
    Client.get!(request_url).body
    |> Poison.decode!(as: %{"posts" => [%Post{}]})
    |> Map.get("posts")
  end

  @doc """
  For a given URL, returns a mapped list of popular and recommended tags.

  ## Example

      iex> Pinboardixir.Posts.suggest("http://www.ulisp.com/")
      %{"popular" => [],
      "recommended" => ["arduino", "lisp", "hardware", "programming", "compiler",
      "scheme"]}
  """
  @spec suggest(String.t) :: Map.t
  def suggest(url) do
    request_url = "/posts/suggest" <> build_params([url: url], [:url])
    Client.get!(request_url).body
    |> Poison.decode!
    |> Enum.reduce(Map.new, fn x, acc -> Map.merge(x, acc) end)
  end

end
