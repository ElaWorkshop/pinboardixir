defmodule Pinboardixir.Utils do
  @moduledoc """
  Provides utility functions for other modules.
  """

  @doc """
  Filter raw_options with valid_options, then build the url parameters string.
  """
  def build_params(nil, _), do: ""
  def build_params(raw_options, valid_options) do
    raw_options
    |> Keyword.take(valid_options)
    |> Enum.map_join("&", fn {k, v} -> "#{Atom.to_string(k)}=#{v}" end)
    |> URI.encode
    |> prefix_question_mark
  end

  defp prefix_question_mark(""), do: ""
  defp prefix_question_mark(query_string), do: "?" <> query_string
end
