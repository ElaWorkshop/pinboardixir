defmodule Pinboardixir.User do
  @moduledoc """
  Endpoints under "/user".
  """

  alias Pinboardixir.Client

  @doc """
  Returns the user's secret RSS key.
  """
  @spec secret() :: String.t
  def secret do
    Client.get!("/user/secret").body
    |> Poison.decode!
    |> Map.get("result")
  end

  @doc """
  Returns the user's API token.
  """
  @spec api_token() :: String.t
  def api_token do
    Client.get!("/user/api_token").body
    |> Poison.decode!
    |> Map.get("result")
  end
end
