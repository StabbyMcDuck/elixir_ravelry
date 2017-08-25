defmodule ElixirRavelryWeb.CardingControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.CardingCase

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

  test "GET /api/v1/carding without carding", %{conn: conn} do
    conn = get conn, "/api/v1/carding"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/carding with carding", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    carding = create_carding(bolt_sips_conn)
    conn = get conn, "/api/v1/carding"
    assert json_response(conn, 200) == [%{"id" => carding.id, "name" => carding.name}]
  end

  test "GET /api/v1/carding/:id without carding", %{conn: conn} do
    conn = get conn, "/api/v1/carding/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/carding/:id with carding", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    carding = create_carding(bolt_sips_conn)
    conn = get conn, "/api/v1/carding/#{carding.id}"
    assert json_response(conn, 200) == %{"id" => carding.id, "name" => carding.name}
  end
end
