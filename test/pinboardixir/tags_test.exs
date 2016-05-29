defmodule Pinboardixir.TagsTest do
  use ExUnit.Case, async: true

  alias Plug.Conn

  setup do
    bypass = Bypass.open
    Application.put_env(:pinboardixir, :base_endpoint, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "`get/0` should return a Map of tags to count", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/tags/get"
      assert conn.method == "GET"

      Conn.resp(conn, 200, ~s<{"Agent":"1","Alchemist":"1","Animation":"3","Apple":"1"}>)
    end

    tags = Pinboardixir.Tags.get
    assert Enum.count(tags) == 4
    assert Map.get(tags, "Animation") == 3
  end

  test "`delete/1` should return a `result` as String", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/tags/delete"
      assert conn.method == "GET"

      conn = Conn.fetch_query_params conn
      assert conn.query_params["tag"] == "Elixir"

      Conn.resp(conn, 200, ~s<{"result":"done"}>)
    end

    result = Pinboardixir.Tags.delete("Elixir")
    assert result == "done"
  end

  test "`rename/2` should return a `result` as String", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/tags/rename"
      assert conn.method == "GET"

      conn = Conn.fetch_query_params conn
      assert conn.query_params["old"] == "Eixir"
      assert conn.query_params["new"] == "Elixir"

      Conn.resp(conn, 200, ~s<{"result":"done"}>)
    end

    result = Pinboardixir.Tags.rename("Eixir", "Elixir")
    assert result == "done"
  end
end
