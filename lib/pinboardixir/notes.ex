defmodule Pinboardixir.Note do
  @moduledoc false

  @doc """
  The structure is defined as returned from Pinboard's API.

  Be ware that `text` seems not returned from "/notes/list".
  """
  defstruct [
    :id,
    :title,
    :text,
    :length,
    :hash,
    :created_at,
    :updated_at,
  ]
end

defmodule Pinboardixir.Notes do
  @moduledoc """
  Endpoints under "/notes".
  """

  alias Pinboardixir.Client
  alias Pinboardixir.Note

  @doc """
  Returns a list of the user's notes.
  """
  @spec list() :: [Note.t]
  def list do
    Client.get!("/notes/list").body
    |> Poison.decode!(as: %{"notes" => [%Note{}]})
    |> Map.get("notes")
  end

  @doc """
  Returns an individual user note.
  """
  @spec get(String.t) :: Note.t
  def get(id) do
    Client.get!("/notes/" <> id).body
    |> Poison.decode!(as: %Note{})
  end
end
