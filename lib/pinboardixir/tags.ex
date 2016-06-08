defmodule Pinboardixir.Tags do
  @moduledoc """
  Endpoints under "/tags"
  """
  import Pinboardixir.Utils

  alias Pinboardixir.Client
  alias Pinboardixir.Types

  @doc """
  Returns a full list of the user's tags along with the number of times they were used.
  """
  @spec get() :: %{String.t => integer}
  def get do
    Client.get!("/tags/get").body
    |> Poison.decode!
    |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
    |> Enum.into(Map.new)
  end

  @doc """
  Delete an existing tag.
  """
  @spec delete(String.t) :: Types.result
  def delete(tag) do
    request_url = "/tags/delete" <> build_params([tag: tag])
    Client.get!(request_url).body
    |> Poison.decode!
    |> Map.get("result")
    |> convert_result
  end

  @doc """
  Rename an tag, or fold it in to an existing tag.
  """
  @spec rename(String.t, String.t) :: Types.result
  def rename(old_tag, new_tag) do
    request_url = "/tags/rename" <> build_params([old: old_tag, new: new_tag])
    Client.get!(request_url).body
    |> Poison.decode!
    |> Map.get("result")
    |> convert_result
  end
end
