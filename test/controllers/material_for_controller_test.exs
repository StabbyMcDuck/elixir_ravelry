defmodule ElixirRavelryWeb.Material_forControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.{Material_forCase}

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

  test "GET /api/v1/material_for without material_for", %{conn: conn} do
    conn = get conn, "/api/v1/material_for"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/material_for with material_for", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    material_for = create_material_for(bolt_sips_conn)
    conn = get conn, "/api/v1/material_for"
    assert json_response(conn, 200) == [%{"id" => material_for.id, "wool_id" => material_for.wool_id, "carding_id" => material_for.carding_id}]
  end

  test "GET /api/v1/material_for/:id without material_for", %{conn: conn} do
    conn = get conn, "/api/v1/material_for/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/material_for/:id with material_for", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    material_for = create_material_for(bolt_sips_conn)
    conn = get conn, "/api/v1/material_for/#{material_for.id}"
    assert json_response(conn, 200) == %{"id" => material_for.id, "wool_id" => material_for.wool_id, "carding_id" => material_for.carding_id}
  end
end
