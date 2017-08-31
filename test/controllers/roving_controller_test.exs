defmodule ElixirRavelryWeb.RovingControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.RovingCase

  # Callbacks

  setup %{conn: conn} do
    bolt_sips_conn = Bolt.Sips.conn()
                     |> Bolt.Sips.begin()

    on_exit fn ->
      Bolt.Sips.rollback(bolt_sips_conn)
    end

    conn = Plug.Conn.put_private(conn, :bolt_sips_conn, bolt_sips_conn)

    %{bolt_sips_conn: bolt_sips_conn, conn: conn}
  end

  # Test

  test "GET /api/v1/roving without roving", %{conn: conn} do
    conn = get conn, "/api/v1/roving"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/roving with roving", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    roving = create_roving(bolt_sips_conn)
    conn = get conn, "/api/v1/roving"
    assert json_response(conn, 200) == [%{"id" => roving.id, "name" => roving.name, "type" => "Roving"}]
  end

  test "GET /api/v1/roving/:id without roving", %{conn: conn} do
    conn = get conn, "/api/v1/roving/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/roving/:id with roving", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    roving = create_roving(bolt_sips_conn)
    conn = get conn, "/api/v1/roving/#{roving.id}"
    assert json_response(conn, 200) == %{"id" => roving.id, "name" => roving.name, "type" => "Roving"}
  end
end
