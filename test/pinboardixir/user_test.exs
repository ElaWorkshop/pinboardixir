defmodule Pinboardixir.UserTest do
  use ExUnit.Case, async: true

  alias Plug.Conn

  setup do
    bypass = Bypass.open
    Application.put_env(:pinboardixir, :base_endpoint, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "`secret/0` should return a String", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/user/secret"
      assert conn.method == "GET"

      Conn.resp(conn, 200, ~s<{"result":"secret_key"}>)
    end

    key = Pinboardixir.User.secret
    assert key == "secret_key"
  end

  test "`api_token/0` should return a String", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/user/api_token"
      assert conn.method == "GET"

      Conn.resp(conn, 200, ~s<{"result":"secret_key"}>)
    end

    key = Pinboardixir.User.api_token
    assert key == "secret_key"
  end
end
