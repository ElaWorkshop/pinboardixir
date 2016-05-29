defmodule Pinboardixir.Utils do
  @moduledoc """
  Utility functions for other modules.
  """

  @doc """
  Build a query string from `raw_options`.
  """
  def build_params(raw_options) do
    raw_options
    |> URI.encode_query
    |> prefix_question_mark
  end

  @doc """
  Filter `raw_options` with `valid_options`, then build a query string.
  """
  def build_params(raw_options, valid_options) do
    raw_options
    |> Keyword.take(valid_options)
    |> URI.encode_query
    |> prefix_question_mark
  end

  defp prefix_question_mark(""), do: ""
  defp prefix_question_mark(query_string), do: "?" <> query_string
end
