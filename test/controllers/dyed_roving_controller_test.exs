defmodule ElixirRavelryWeb.DyedRovingControllerTest do
  use ElixirRavelryWeb.ConnCase
  use ElixirRavelry.Neo4jConnCase

  import ElixirRavelry.DyedRovingCase

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
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in nodes
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in nodes
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in nodes
    end

    test "With dyed_roving forward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        dyed_roving: dyed_roving,
      } = create_connected_dyed_roving(bolt_sips_conn)
      conn = get conn, "/api/v1/dyed_roving/#{dyed_roving.id}/graph", %{"direction" => "forward"}
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in nodes
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
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in nodes
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in nodes
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in nodes
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
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in nodes
      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in nodes
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in nodes
    end
  end
end