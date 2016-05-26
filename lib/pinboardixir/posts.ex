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
  @moduledoc """
  Endpoints under "/posts".
  """
  alias Pinboardixir.Client

  alias Pinboardixir.Post
  import Pinboardixir.Utils

  @valid_all_options [:tag, :start, :results, :fromdt, :todt, :meta, :toread]

  @doc """
  Get all bookmarks in the user's account, return a list of `Pinboardixir.Post` structs.

  You can pass a Keyword List as options, refer to the [official documentation](https://pinboard.in/api/#posts_all) for explaination and example. Additional notes:

  - All values should be String, booleans are represented as "yes" or "no"
  - `:tag` to filter by multiple tags, seperate them by ","
  - Although not documented, `:toread` can be used to filter posts marked as "read later"
  """
  def all(options \\ nil) do
    Client.get!("/all" <> build_params(options, @valid_all_options)).body
    |> Poison.decode!(as: [%Post{}])
  end

end
