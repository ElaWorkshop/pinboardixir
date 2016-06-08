defmodule Pinboardixir.Utils do
  @moduledoc """
  Utility functions for other modules.
  """

  alias Pinboardixir.Types

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

  @doc """
  Convert `result_code` to `:ok` or `{:error, reason}`.
  """
  @spec convert_result(String.t) :: Types.result
  def convert_result("done"), do: :ok
  def convert_result(error_reason), do: {:error, error_reason}
end
