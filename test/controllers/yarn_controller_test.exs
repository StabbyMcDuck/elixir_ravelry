defmodule ElixirRavelryWeb.YarnControllerTest do
  use ElixirRavelryWeb.ConnCase
  use ElixirRavelry.Neo4jConnCase

  import ElixirRavelry.YarnCase

  # Test

  test "GET /api/v1/yarn without yarn", %{conn: conn} do
    conn = get conn, "/api/v1/yarn"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/yarn with yarn", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    yarn = create_yarn(bolt_sips_conn)
    conn = get conn, "/api/v1/yarn"
    assert json_response(conn, 200) == [%{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"}]
  end

  test "GET /api/v1/yarn/:id without yarn", %{conn: conn} do
    conn = get conn, "/api/v1/yarn/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/yarn/:id with yarn", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    yarn = create_yarn(bolt_sips_conn)
    conn = get conn, "/api/v1/yarn/#{yarn.id}"
    assert json_response(conn, 200) == %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"}
  end

  describe "GET /api/v1/yarn/:yarn_id/graph" do
    test "Without yarn", %{conn: conn} do
      conn = get conn, "/api/v1/yarn/-1/graph"
      assert json_response(conn, 404) == %{"error" => "Not Found"}
    end

    test "With yarn", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        roving: roving,
        roving_material_for_yarn: roving_material_for_yarn,
        yarn: yarn,
        wool: wool,
        wool_material_for_roving: wool_material_for_roving
      } = create_connected_yarn(bolt_sips_conn)
      conn = get conn, "/api/v1/yarn/#{yarn.id}/graph"
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)

      assert %{
               "end_node_id" => roving_material_for_yarn.end_node_id,
               "id" => roving_material_for_yarn.id,
               "start_node_id" => roving_material_for_yarn.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in nodes
      assert %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"} in nodes
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in nodes
    end

    test "With yarn forward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        yarn: yarn,
      } = create_connected_yarn(bolt_sips_conn)
      conn = get conn, "/api/v1/yarn/#{yarn.id}/graph", %{"direction" => "forward"}
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)
      assert %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"} in nodes
    end

    test "With yarn backward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        roving: roving,
        roving_material_for_yarn: roving_material_for_yarn,
        yarn: yarn,
        wool: wool,
        wool_material_for_roving: wool_material_for_roving
      } = create_connected_yarn(bolt_sips_conn)
      conn = get conn, "/api/v1/yarn/#{yarn.id}/graph", %{"direction" => "backwards"}
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)

      assert %{
               "end_node_id" => roving_material_for_yarn.end_node_id,
               "id" => roving_material_for_yarn.id,
               "start_node_id" => roving_material_for_yarn.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in nodes
      assert %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"} in nodes
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in nodes
    end

    test "With yarn both", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        roving: roving,
        roving_material_for_yarn: roving_material_for_yarn,
        yarn: yarn,
        wool: wool,
        wool_material_for_roving: wool_material_for_roving
      } = create_connected_yarn(bolt_sips_conn)
      conn = get conn, "/api/v1/yarn/#{yarn.id}/graph", %{"direction" => "both"}
      assert %{"nodes" => nodes, "relationships" => relationships} = json_response(conn, 200)
      assert is_list(nodes)
      assert is_list(relationships)

      assert %{
               "end_node_id" => roving_material_for_yarn.end_node_id,
               "id" => roving_material_for_yarn.id,
               "start_node_id" => roving_material_for_yarn.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in relationships
      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in nodes
      assert %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"} in nodes
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in nodes
    end
  end
end