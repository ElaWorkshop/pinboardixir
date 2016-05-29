defmodule Pinboardixir.PostsTest do
  use ExUnit.Case, async: true

  alias Plug.Conn

  setup do
    bypass = Bypass.open
    Application.put_env(:pinboardixir, :base_endpoint, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "`update/0` should return a DateTime (currently as String)", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/update"
      assert conn.method == "GET"

      Conn.resp(conn, 200, ~s<{"update_time":"2016-05-28T10:50:51Z"}>)
    end

    update_time = Pinboardixir.Posts.update
    assert update_time == "2016-05-28T10:50:51Z"
  end

  test "`all/1` should return a list of `Pinboardixir.Post`", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/all"
      assert conn.method == "GET"

      Conn.resp(conn, 200, ~s"""
      [{"href":"https:\/\/www.inverse.com\/article\/10674-here-s-how-inverse-tests-external-apis-in-elixir-with-bypass","description":"Here's How Inverse Tests External APIs in Elixir with Bypass | Inverse","extended":"","meta":"84e86a26498c391f66663d0974f6001e","hash":"f9153afe872f421073cda4219d0429d0","time":"2016-05-26T11:17:28Z","shared":"yes","toread":"no","tags":"Elixir Test Bypass Mock"},{"href":"http:\/\/nsomar.com\/elixir-enumerated-types\/","description":"Enumerated types in Elixir","extended":"","meta":"aace15c2b83cd4a7bedf12bd430677ff","hash":"165f8a7353a76c7c3a3a1458d84b3420","time":"2016-05-26T09:12:09Z","shared":"yes","toread":"no","tags":"Elixir"}]
      """)
    end

    posts = Pinboardixir.Posts.all()
    assert Enum.count(posts) == 2
  end

  test "`get/1` should return a list of `Pinboardixir.Post` for a given date", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/get"
      assert conn.method == "GET"
      assert String.contains?(conn.query_string, "dt=2016-05-26")

      Conn.resp(conn, 200, ~s"""
      {"date":"2016-05-26T09:12:09Z","user":"aquarhead","posts":[{"href":"http:\/\/nsomar.com\/elixir-enumerated-types\/","description":"Enumerated types in Elixir","extended":"","meta":"aace15c2b83cd4a7bedf12bd430677ff","hash":"165f8a7353a76c7c3a3a1458d84b3420","time":"2016-05-26T09:12:09Z","shared":"yes","toread":"no","tags":"Elixir"},{"href":"https:\/\/www.inverse.com\/article\/10674-here-s-how-inverse-tests-external-apis-in-elixir-with-bypass","description":"Here's How Inverse Tests External APIs in Elixir with Bypass | Inverse","extended":"","meta":"84e86a26498c391f66663d0974f6001e","hash":"f9153afe872f421073cda4219d0429d0","time":"2016-05-26T11:17:28Z","shared":"yes","toread":"no","tags":"Elixir Test Bypass Mock"}]}
      """)
    end

    posts = Pinboardixir.Posts.get([dt: "2016-05-26"])
    assert Enum.count(posts) == 2
    #TODO: Add proper date check when Elixir 1.3 release
    assert (
      posts
      |> List.first
      |> Map.get(:time)
      |> String.starts_with?("2016-05-26")
    )
  end

  test "`add/3` should return the `result_code`", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/add"
      assert conn.method == "GET" #"All API methods are GET requests"

      conn = Conn.fetch_query_params conn
      assert conn.query_params["url"] == "http://example.com"
      assert conn.query_params["description"] == "Test Title"
      assert conn.query_params["tags"] == "Elixir,Test"

      Conn.resp(conn, 200, ~s<{"result_code":"done"}>)
    end

    result_code = Pinboardixir.Posts.add("http://example.com",
      "Test Title",
      [tags: "Elixir,Test"])
    assert result_code == "done"
  end

  test "`delete/1` should return the `result_code`", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/delete"
      assert conn.method == "GET"

      conn = Conn.fetch_query_params conn
      assert conn.query_params["url"] == "http://example.com"

      Conn.resp(conn, 200, ~s<{"result_code":"done"}>)
    end

    result_code = Pinboardixir.Posts.delete("http://example.com")
    assert result_code == "done"
  end

  test "`dates/1` should return a Map with date string as key, int as value", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/dates"
      assert conn.method == "GET"

      conn = Conn.fetch_query_params conn
      assert conn.query_params["tag"] == "Elixir"

      Conn.resp(conn, 200, ~s"""
      {"user":"aquarhead","tag":"Elixir","dates":{"2016-05-28":"1","2016-05-27":"1"}}
      """)
    end

    result = Pinboardixir.Posts.dates([tag: "Elixir"])
    assert Enum.count(result) == 2
    assert Map.get(result, "2016-05-28") == 1
  end

  test "`recent/1` should return a list of `Pinboardixir.Post`", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/recent"
      assert conn.method == "GET"

      conn = Conn.fetch_query_params conn
      assert conn.query_params["tag"] == "Elixir"
      assert conn.query_params["count"] == "2"

      Conn.resp(conn, 200, ~s"""
      {"date":"2016-05-28T08:41:59Z","user":"aquarhead","posts":[{"href":"http:\/\/asquera.de\/blog\/2015-04-10\/writing-a-commandline-app-in-elixir\/","description":"Writing a command line application in Elixir","extended":"","meta":"5c074d2bed814e7573d8dc0617693619","hash":"90e81611fb61b089e19ba99041d12141","time":"2016-05-28T08:41:59Z","shared":"yes","toread":"no","tags":"Elixir CLI"},{"href":"http:\/\/eftimov.net\/writing-elixir-cli-apps","description":"Writing command line apps with Elixir","extended":"","meta":"79842b7d63aa85d288ef326d655e7e5e","hash":"91dee7b47a67bb0d2b732b52bc19d654","time":"2016-05-27T12:41:43Z","shared":"yes","toread":"no","tags":"Elixir CLI"}]}
      """)
    end

    posts = Pinboardixir.Posts.recent([tag: "Elixir", count: "2"])
    assert Enum.count(posts) == 2
  end

  test "`suggest/1` should return a mapped list of tags", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/posts/suggest"
      assert conn.method == "GET"

      conn = Conn.fetch_query_params conn
      assert conn.query_params["url"] == "http://www.ulisp.com/"

      Conn.resp(conn, 200, ~s<[{"popular":[]},{"recommended":["arduino","lisp","hardware","programming","compiler","scheme"]}]>)
    end

    suggested_tags = Pinboardixir.Posts.suggest("http://www.ulisp.com/")
    assert Map.has_key?(suggested_tags, "recommended")
    assert (suggested_tags |> Map.get("recommended") |> Enum.count) == 6
  end
end
