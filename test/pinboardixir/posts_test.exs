defmodule Pinboardixir.PostsTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open
    Application.put_env(:pinboardixir, :base_endpoint, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "`all/1` should return a list of `Pinboardixir.Post`", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/all"
      assert conn.method == "GET"

      Plug.Conn.resp(conn, 200, ~s<[{"href":"https:\/\/www.inverse.com\/article\/10674-here-s-how-inverse-tests-external-apis-in-elixir-with-bypass","description":"Here's How Inverse Tests External APIs in Elixir with Bypass | Inverse","extended":"","meta":"84e86a26498c391f66663d0974f6001e","hash":"f9153afe872f421073cda4219d0429d0","time":"2016-05-26T11:17:28Z","shared":"yes","toread":"no","tags":"Elixir Test Bypass Mock"},{"href":"http:\/\/nsomar.com\/elixir-enumerated-types\/","description":"Enumerated types in Elixir","extended":"","meta":"aace15c2b83cd4a7bedf12bd430677ff","hash":"165f8a7353a76c7c3a3a1458d84b3420","time":"2016-05-26T09:12:09Z","shared":"yes","toread":"no","tags":"Elixir"}]>)
    end

    posts = Pinboardixir.Posts.all()

    assert Enum.count(posts) == 2
  end
end
