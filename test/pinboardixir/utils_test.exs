defmodule Pinboardixir.UtilsTest do
  use ExUnit.Case, async: true

  import Pinboardixir.Utils

  test "build_params with empty options should return an empty string" do
    assert build_params([], [:key]) == ""
  end

  test "build_params should return an encoded query string" do
    assert build_params([tag: "Elixir Test,Tag2"]) == "?tag=Elixir+Test%2CTag2"
  end

  test "build_params should filter out invalid options" do
    assert build_params([tag: "Tag1", invalid: "Unknown"], [:tag]) == "?tag=Tag1"
  end

  test "build_params should return an empty string if no valid option exist" do
    assert build_params([invalid: "Unknown"], [:tag]) == ""
  end
end
