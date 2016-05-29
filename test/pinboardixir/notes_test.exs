defmodule Pinboardixir.NotesTest do
  use ExUnit.Case, async: true

  alias Plug.Conn

  setup do
    bypass = Bypass.open
    Application.put_env(:pinboardixir, :base_endpoint, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "`list/0` should return a list of Note", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/notes/list"
      assert conn.method == "GET"

      Conn.resp(conn, 200, ~s"""
      {"count":1,"notes":[{"id":"1c63133f78e3e0b6cd66","hash":"6389cdabc12b7866b79b","title":"Test note","length":"83","created_at":"2016-05-29 09:05:51","updated_at":"2016-05-29 09:05:51"}]}
      """)
    end

    notes = Pinboardixir.Notes.list
    assert Enum.count(notes) == 1
  end

  test "`get/1` should return a single note", %{bypass: bypass} do
    Bypass.expect bypass, fn conn ->
      assert conn.request_path == "/notes/1c63133f78e3e0b6cd66"

      Conn.resp(conn, 200, ~s"""
      {"id":"1c63133f78e3e0b6cd66","title":"Test note","created_at":"2016-05-29 09:05:51","updated_at":"2016-05-29 09:05:51","length":83,"text":"This is a test note for [Pinboardixir](https:\/\/github.com\/ElaWorkshop\/pinboardixir)","hash":"6389cdabc12b7866b79b"}
      """)
    end

    note = Pinboardixir.Notes.get("1c63133f78e3e0b6cd66")
    assert note.id == "1c63133f78e3e0b6cd66"
    assert note.text == "This is a test note for [Pinboardixir](https://github.com/ElaWorkshop/pinboardixir)"
  end
end
