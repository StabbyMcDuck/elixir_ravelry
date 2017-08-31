defmodule ElixirRavelryWeb.DyeingControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.DyeingCase

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

  test "GET /api/v1/dyeing without dyeing", %{conn: conn} do
    conn = get conn, "/api/v1/dyeing"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/dyeing with dyeing", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    dyeing = create_dyeing(bolt_sips_conn)
    conn = get conn, "/api/v1/dyeing"
    assert json_response(conn, 200) == [%{"id" => dyeing.id, "name" => dyeing.name, "type" => "Dyeing"}]
  end

  test "GET /api/v1/dyeing/:id without dyeing", %{conn: conn} do
    conn = get conn, "/api/v1/dyeing/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/dyeing/:id with dyeing", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    dyeing = create_dyeing(bolt_sips_conn)
    conn = get conn, "/api/v1/dyeing/#{dyeing.id}"
    assert json_response(conn, 200) == %{"id" => dyeing.id, "name" => dyeing.name, "type" => "Dyeing"}
  end

  describe "GET /api/v1/dyeing/:dyeing_id/graph" do
    test "Without dyeing", %{conn: conn} do
      conn = get conn, "/api/v1/dyeing/-1/graph"
      assert json_response(conn, 404) == %{"error" => "Not Found"}
    end

    test "With dyeing", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        carding: carding,
        carding_material_for_dyeing: carding_material_for_dyeing,
        dyeing: dyeing,
        wool: wool,
        wool_material_for_carding: wool_material_for_carding
      } = create_connected_dyeing(bolt_sips_conn)
      conn = get conn, "/api/v1/dyeing/#{dyeing.id}/graph"
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{
               "end_node_id" => carding_material_for_dyeing.end_node_id,
               "id" => carding_material_for_dyeing.id,
               "start_node_id" => carding_material_for_dyeing.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{
               "end_node_id" => wool_material_for_carding.end_node_id,
               "id" => wool_material_for_carding.id,
               "start_node_id" => wool_material_for_carding.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => carding.id, "name" => carding.name, "type" => "Carding"} in list
      assert %{"id" => dyeing.id, "name" => dyeing.name, "type" => "Dyeing"} in list
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
    end

    test "With dyeing forward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        dyeing: dyeing,
      } = create_connected_dyeing(bolt_sips_conn)
      conn = get conn, "/api/v1/dyeing/#{dyeing.id}/graph", %{"direction" => "forward"}
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{"id" => dyeing.id, "name" => dyeing.name, "type" => "Dyeing"} in list
    end

    test "With dyeing backward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        carding: carding,
        carding_material_for_dyeing: carding_material_for_dyeing,
        dyeing: dyeing,
        wool: wool,
        wool_material_for_carding: wool_material_for_carding
      } = create_connected_dyeing(bolt_sips_conn)
      conn = get conn, "/api/v1/dyeing/#{dyeing.id}/graph", %{"direction" => "backwards"}
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{
               "end_node_id" => carding_material_for_dyeing.end_node_id,
               "id" => carding_material_for_dyeing.id,
               "start_node_id" => carding_material_for_dyeing.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{
               "end_node_id" => wool_material_for_carding.end_node_id,
               "id" => wool_material_for_carding.id,
               "start_node_id" => wool_material_for_carding.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => carding.id, "name" => carding.name, "type" => "Carding"} in list
      assert %{"id" => dyeing.id, "name" => dyeing.name, "type" => "Dyeing"} in list
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
    end

    test "With dyeing both", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        carding: carding,
        carding_material_for_dyeing: carding_material_for_dyeing,
        dyeing: dyeing,
        wool: wool,
        wool_material_for_carding: wool_material_for_carding
      } = create_connected_dyeing(bolt_sips_conn)
      conn = get conn, "/api/v1/dyeing/#{dyeing.id}/graph", %{"direction" => "both"}
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert %{
               "end_node_id" => carding_material_for_dyeing.end_node_id,
               "id" => carding_material_for_dyeing.id,
               "start_node_id" => carding_material_for_dyeing.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{
               "end_node_id" => wool_material_for_carding.end_node_id,
               "id" => wool_material_for_carding.id,
               "start_node_id" => wool_material_for_carding.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => carding.id, "name" => carding.name, "type" => "Carding"} in list
      assert %{"id" => dyeing.id, "name" => dyeing.name, "type" => "Dyeing"} in list
      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
    end
  end
end