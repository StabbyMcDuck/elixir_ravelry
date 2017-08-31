defmodule ElixirRavelryWeb.MaterialForControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.{RovingCase, DyedRovingCase, MaterialForCase, WoolCase}

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

  test "GET /api/v1/material-for without material-for", %{conn: conn} do
    conn = get conn, "/api/v1/material-for"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/material-for with material-for", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)

    first_material_for = create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: roving.id})

    dyed_roving = create_dyed_roving(bolt_sips_conn)

    second_material_for = create_material_for(bolt_sips_conn, %{start_node_id: roving.id, end_node_id: dyed_roving.id})

    conn = get conn, "/api/v1/material-for"

    assert material_fors = json_response(conn, 200)
    assert is_list(material_fors)
    assert %{"id" => first_material_for.id, "start_node_id" => wool.id, "end_node_id" => roving.id, "type" => "MaterialFor"} in material_fors
    assert %{"id" => second_material_for.id, "start_node_id" => roving.id, "end_node_id" => dyed_roving.id, "type" => "MaterialFor"} in material_fors
  end

  test "GET /api/v1/material-for/:id without material_for", %{conn: conn} do
    conn = get conn, "/api/v1/material-for/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/material-for/:id with material_for", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)

    material_for = create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: roving.id})

    conn = get conn, "/api/v1/material-for/#{material_for.id}"
    assert json_response(conn, 200) == %{"id" => material_for.id, "start_node_id" => wool.id, "end_node_id" => roving.id, "type" => "MaterialFor"}
  end
end
