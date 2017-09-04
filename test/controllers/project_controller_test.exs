defmodule ElixirRavelryWeb.ProjectControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.{GraphCase, ProjectCase}

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

  test "GET /api/v1/projects without project", %{conn: conn} do
    conn = get conn, "/api/v1/projects"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/projects with project", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    project = create_project(bolt_sips_conn)
    conn = get conn, "/api/v1/projects"
    assert json_response(conn, 200) == [%{"id" => project.id, "name" => project.name, "type" => "Project"}]
  end

  test "GET /api/v1/projects/:id without project", %{conn: conn} do
    conn = get conn, "/api/v1/projects/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/projects/:id with project", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    project = create_project(bolt_sips_conn)
    conn = get conn, "/api/v1/projects/#{project.id}"
    assert json_response(conn, 200) == %{"id" => project.id, "name" => project.name, "type" => "Project"}
  end

  describe "GET /api/v1/projects/:project_id/graph" do
    test "Without project", %{conn: conn} do
      conn = get conn, "/api/v1/projects/-1/graph"
      assert json_response(conn, 404) == %{"error" => "Not Found"}
    end

    test "With project", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        wool: wool,
        wool_material_for_roving: wool_material_for_roving,
        cards: cards,
        cards_user: cards_user,
        roving: roving,
        roving_material_for_dyed_roving: roving_material_for_dyed_roving,
        dyes: dyes,
        dyes_user: dyes_user,
        dyed_roving: dyed_roving,
        dyed_roving_material_for_yarn: dyed_roving_material_for_yarn,
        spins: spins,
        spins_user: spins_user,
        yarn: yarn,
        yarn_material_for_project: yarn_material_for_project,
        knits: knits,
        knits_user: knits_user,
        project: project,
      } = create_connected_project(bolt_sips_conn)
      conn = get conn, "/api/v1/projects/#{project.id}/graph"
      assert list = json_response(conn, 200)
      assert is_list(list)

      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{
               "roving_id" => cards.roving_id,
               "id" => cards.id,
               "user_id" => cards_user.id,
               "type" => "Cards"
             } in list

      assert %{
               "name" => cards_user.name,
               "id" => cards_user.id,
               "type" => "User"
             } in list

      assert %{
               "dyed_roving_id" => dyes.dyed_roving_id,
               "id" => dyes.id,
               "user_id" => dyes_user.id,
               "type" => "Dyes"
             } in list

      assert %{
               "name" => dyes_user.name,
               "id" => dyes_user.id,
               "type" => "User"
             } in list

      assert %{
               "yarn_id" => spins.yarn_id,
               "id" => spins.id,
               "user_id" => spins_user.id,
               "type" => "Spins"
             } in list

      assert %{
               "name" => spins_user.name,
               "id" => spins_user.id,
               "type" => "User"
             } in list

      assert %{
               "project_id" => knits.project_id,
               "id" => knits.id,
               "user_id" => knits_user.id,
               "type" => "Knits"
             } in list

      assert %{
               "name" => knits_user.name,
               "id" => knits_user.id,
               "type" => "User"
             } in list

      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in list
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in list
      assert %{
               "end_node_id" => dyed_roving_material_for_yarn.end_node_id,
               "id" => dyed_roving_material_for_yarn.id,
               "start_node_id" => dyed_roving_material_for_yarn.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"} in list
      assert %{
               "end_node_id" => yarn_material_for_project.end_node_id,
               "id" => yarn_material_for_project.id,
               "start_node_id" => yarn_material_for_project.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => project.id, "name" => project.name, "type" => "Project"} in list
    end

    test "With project forward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        project: project,
      } = create_connected_project(bolt_sips_conn)
      conn = get conn, "/api/v1/projects/#{project.id}/graph", %{"direction" => "forward"}
      assert list = json_response(conn, 200)
      assert is_list(list)

      assert %{"id" => project.id, "name" => project.name, "type" => "Project"} in list
    end

    test "With project backward", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        wool: wool,
        wool_material_for_roving: wool_material_for_roving,
        cards: cards,
        cards_user: cards_user,
        roving: roving,
        roving_material_for_dyed_roving: roving_material_for_dyed_roving,
        dyes: dyes,
        dyes_user: dyes_user,
        dyed_roving: dyed_roving,
        dyed_roving_material_for_yarn: dyed_roving_material_for_yarn,
        spins: spins,
        spins_user: spins_user,
        yarn: yarn,
        yarn_material_for_project: yarn_material_for_project,
        knits: knits,
        knits_user: knits_user,
        project: project,
      } = create_connected_project(bolt_sips_conn)
      conn = get conn, "/api/v1/projects/#{project.id}/graph", %{"direction" => "backwards"}
      assert list = json_response(conn, 200)
      assert is_list(list)

      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{
               "roving_id" => cards.roving_id,
               "id" => cards.id,
               "user_id" => cards_user.id,
               "type" => "Cards"
             } in list

      assert %{
               "name" => cards_user.name,
               "id" => cards_user.id,
               "type" => "User"
             } in list

      assert %{
               "dyed_roving_id" => dyes.dyed_roving_id,
               "id" => dyes.id,
               "user_id" => dyes_user.id,
               "type" => "Dyes"
             } in list

      assert %{
               "name" => dyes_user.name,
               "id" => dyes_user.id,
               "type" => "User"
             } in list

      assert %{
               "yarn_id" => spins.yarn_id,
               "id" => spins.id,
               "user_id" => spins_user.id,
               "type" => "Spins"
             } in list

      assert %{
               "name" => spins_user.name,
               "id" => spins_user.id,
               "type" => "User"
             } in list

      assert %{
               "project_id" => knits.project_id,
               "id" => knits.id,
               "user_id" => knits_user.id,
               "type" => "Knits"
             } in list

      assert %{
               "name" => knits_user.name,
               "id" => knits_user.id,
               "type" => "User"
             } in list

      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in list
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in list
      assert %{
               "end_node_id" => dyed_roving_material_for_yarn.end_node_id,
               "id" => dyed_roving_material_for_yarn.id,
               "start_node_id" => dyed_roving_material_for_yarn.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"} in list
      assert %{
               "end_node_id" => yarn_material_for_project.end_node_id,
               "id" => yarn_material_for_project.id,
               "start_node_id" => yarn_material_for_project.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => project.id, "name" => project.name, "type" => "Project"} in list
    end

    test "With project backwards only users", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        cards_user: cards_user,
        dyes_user: dyes_user,
        spins_user: spins_user,
        knits_user: knits_user,
        project: project
      } = create_connected_project(bolt_sips_conn)
      conn = get conn, "/api/v1/projects/#{project.id}/graph", %{"direction" => "backwards", "type" => "User"}
      assert list = json_response(conn, 200)
      assert is_list(list)
      assert length(list) == 8 # 4 users + 4 roles

      assert %{
               "name" => cards_user.name,
               "id" => cards_user.id,
               "type" => "User"
             } in list

      assert %{
               "name" => dyes_user.name,
               "id" => dyes_user.id,
               "type" => "User"
             } in list

      assert %{
               "name" => spins_user.name,
               "id" => spins_user.id,
               "type" => "User"
             } in list

      assert %{
               "name" => knits_user.name,
               "id" => knits_user.id,
               "type" => "User"
             } in list

    end

    test "With project both", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
      %{
        wool: wool,
        wool_material_for_roving: wool_material_for_roving,
        cards: cards,
        cards_user: cards_user,
        roving: roving,
        roving_material_for_dyed_roving: roving_material_for_dyed_roving,
        dyes: dyes,
        dyes_user: dyes_user,
        dyed_roving: dyed_roving,
        dyed_roving_material_for_yarn: dyed_roving_material_for_yarn,
        spins: spins,
        spins_user: spins_user,
        yarn: yarn,
        yarn_material_for_project: yarn_material_for_project,
        knits: knits,
        knits_user: knits_user,
        project: project,
      } = create_connected_project(bolt_sips_conn)
      conn = get conn, "/api/v1/projects/#{project.id}/graph", %{"direction" => "both"}
      assert list = json_response(conn, 200)
      assert is_list(list)

      assert %{"id" => wool.id, "name" => wool.name, "type" => "Wool"} in list
      assert %{
               "end_node_id" => wool_material_for_roving.end_node_id,
               "id" => wool_material_for_roving.id,
               "start_node_id" => wool_material_for_roving.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{
               "roving_id" => cards.roving_id,
               "id" => cards.id,
               "user_id" => cards_user.id,
               "type" => "Cards"
             } in list

      assert %{
               "name" => cards_user.name,
               "id" => cards_user.id,
               "type" => "User"
             } in list

      assert %{
               "dyed_roving_id" => dyes.dyed_roving_id,
               "id" => dyes.id,
               "user_id" => dyes_user.id,
               "type" => "Dyes"
             } in list

      assert %{
               "name" => dyes_user.name,
               "id" => dyes_user.id,
               "type" => "User"
             } in list

      assert %{
               "yarn_id" => spins.yarn_id,
               "id" => spins.id,
               "user_id" => spins_user.id,
               "type" => "Spins"
             } in list

      assert %{
               "name" => spins_user.name,
               "id" => spins_user.id,
               "type" => "User"
             } in list

      assert %{
               "project_id" => knits.project_id,
               "id" => knits.id,
               "user_id" => knits_user.id,
               "type" => "Knits"
             } in list

      assert %{
               "name" => knits_user.name,
               "id" => knits_user.id,
               "type" => "User"
             } in list

      assert %{"id" => roving.id, "name" => roving.name, "type" => "Roving"} in list
      assert %{
               "end_node_id" => roving_material_for_dyed_roving.end_node_id,
               "id" => roving_material_for_dyed_roving.id,
               "start_node_id" => roving_material_for_dyed_roving.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{"id" => dyed_roving.id, "name" => dyed_roving.name, "type" => "DyedRoving"} in list
      assert %{
               "end_node_id" => dyed_roving_material_for_yarn.end_node_id,
               "id" => dyed_roving_material_for_yarn.id,
               "start_node_id" => dyed_roving_material_for_yarn.start_node_id,
               "type" => "MaterialFor"
             } in list

      assert %{"id" => yarn.id, "name" => yarn.name, "type" => "Yarn"} in list
      assert %{
               "end_node_id" => yarn_material_for_project.end_node_id,
               "id" => yarn_material_for_project.id,
               "start_node_id" => yarn_material_for_project.start_node_id,
               "type" => "MaterialFor"
             } in list
      assert %{"id" => project.id, "name" => project.name, "type" => "Project"} in list
    end
  end
end