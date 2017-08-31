defmodule ElixirRavelryWeb.DyedRovingControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.DyedRovingCase

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

  test "GET /api/v1/dyed_roving without dyed_roving", %{conn: conn} do
    conn = get conn, "/api/v1/dyed_roving"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/dyed_roving with dyed_roving", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    dyed_roving = create_dyed_roving(bolt_sips_conn)
    conn = get conn, "/api/v1/dyed_roving"
    assert json_response(conn, 200) == [%{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"}]
  end

  test "GET /api/v1/dyed_roving/:id without dyed_roving", %{conn: conn} do
    conn = get conn, "/api/v1/dyed_roving/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/dyed_roving/:id with dyed_roving", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    dyed_roving = create_dyed_roving(bolt_sips_conn)
    conn = get conn, "/api/v1/dyed_roving/#{dyed_roving.id}"
    assert json_response(conn, 200) == %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"}
  end

  describe "GET /api/v1/dyed_roving/:dyed_roving_id/graph" do
    test "Without dyed_roving", %{conn: conn} do
      conn = get conn, "/api/v1/dyed_roving/-1/graph"
      assert json_response(conn, 404) == %{"error" => "Not Found"}
    end

    test "With dyed_roving", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        roving: roving,
        roving_material_for_dyed_roving: roving_material_for_dyed_roving,
        dyed_roving: dyed_roving,
        wool: wool,
        wool_material_for_roving: wool_material_for_roving
      } = create_connected_dyed_roving(bolt_sips_conn)
      conn = get conn, "/api/v1/dyed_roving/#{dyed_roving.id}/graph"
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in list
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in list
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
    end

    test "With dyed_roving forward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        dyed_roving: dyed_roving,
      } = create_connected_dyed_roving(bolt_sips_conn)
      conn = get conn, "/api/v1/dyed_roving/#{dyed_roving.id}/graph", %{"direction" => "forward"}
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in list
    end

    test "With dyed_roving backward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        roving: roving,
        roving_material_for_dyed_roving: roving_material_for_dyed_roving,
        dyed_roving: dyed_roving,
        wool: wool,
        wool_material_for_roving: wool_material_for_roving
      } = create_connected_dyed_roving(bolt_sips_conn)
      conn = get conn, "/api/v1/dyed_roving/#{dyed_roving.id}/graph", %{"direction" => "backwards"}
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in list
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in list
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
    end

    test "With dyed_roving both", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        roving: roving,
        roving_material_for_dyed_roving: roving_material_for_dyed_roving,
        dyed_roving: dyed_roving,
        wool: wool,
        wool_material_for_roving: wool_material_for_roving
      } = create_connected_dyed_roving(bolt_sips_conn)
      conn = get conn, "/api/v1/dyed_roving/#{dyed_roving.id}/graph", %{"direction" => "both"}
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in list
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in list
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
    end
  end
end