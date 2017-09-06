defmodule ElixirRavelryWeb.CardsControllerTest do
  use ElixirRavelryWeb.ConnCase
  use ElixirRavelry.Neo4jConnCase

  import ElixirRavelry.{CardsCase, DyedRovingCase, DyesCase, KnitsCase, MaterialForCase, ProjectCase, RovingCase,
                        SpinsCase, UserCase, WoolCase, YarnCase}
  import Phoenix.ChannelTest
  # Test

  test "GET /api/v1/cards without cards", %{conn: conn} do
    conn = get conn, "/api/v1/cards"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/cards with cards", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    roving = create_roving(bolt_sips_conn)
    user = create_user(bolt_sips_conn)
    cards = create_cards(bolt_sips_conn, %{user_id: user.id, roving_id: roving.id})
    conn = get conn, "/api/v1/cards"
    assert json_response(conn, 200) == [%{"id" => cards.id, "user_id" => cards.user_id, "roving_id" => cards.roving_id, "type" => "Cards"}]
  end

  test "GET /api/v1/cards/:id without cards", %{conn: conn} do
    conn = get conn, "/api/v1/cards/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/cards/:id with cards", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    roving = create_roving(bolt_sips_conn)
    user = create_user(bolt_sips_conn)
    cards = create_cards(bolt_sips_conn, %{user_id: user.id, roving_id: roving.id})
    conn = get conn, "/api/v1/cards/#{cards.id}"
    assert json_response(conn, 200) == %{"id" => cards.id, "user_id" => cards.user_id, "roving_id" => cards.roving_id, "type" => "Cards"}
  end

  test "POST /api/v1/cards with new socket", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)
    cards_user = create_user(bolt_sips_conn)
    # Missing cards as it will be created by controller call!!!
    dyed_roving = create_dyed_roving(bolt_sips_conn)
    dyes_user = create_user(bolt_sips_conn)
    create_dyes(bolt_sips_conn, %{dyed_roving_id: dyed_roving.id, user_id: dyes_user.id})
    create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: roving.id})
    create_material_for(bolt_sips_conn, %{start_node_id: roving.id, end_node_id: dyed_roving.id})
    yarn = create_yarn(bolt_sips_conn)
    spins_user = create_user(bolt_sips_conn)
    create_spins(bolt_sips_conn, %{yarn_id: yarn.id, user_id: spins_user.id})
    create_material_for(bolt_sips_conn, %{start_node_id: dyed_roving.id, end_node_id: yarn.id})
    project = create_project(bolt_sips_conn)
    knits_user = create_user(bolt_sips_conn)
    create_knits(bolt_sips_conn, %{project_id: project.id, user_id: knits_user.id})
    create_material_for(bolt_sips_conn, %{start_node_id: yarn.id, end_node_id: project.id})

    socket = socket("user_id", %{})
    nodes = [wool, roving, dyed_roving, yarn, project]
    Enum.reduce(nodes, socket, fn node, acc_socket ->
      {:ok, _, subscribed_socket} = subscribe_and_join(acc_socket, ElixirRavelryWeb.GraphChannel, "graph:#{node.id}")
      subscribed_socket
    end)

    conn = post conn, "/api/v1/cards", %{user_id: cards_user.id, roving_id: roving.id}

    user_id = cards_user.id
    roving_id = roving.id
    assert %{"id" => _, "user_id" => ^user_id, "roving_id" => ^roving_id, "type" => "Cards"} = json_response(conn, 201)

    Enum.each(nodes, fn node ->
      topic = "graph:#{node.id}"
      assert_receive %Phoenix.Socket.Broadcast{event: "graph_update", topic: ^topic}
    end)
  end

  test "POST /api/v1/cards with existing socket", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)
    cards_user = create_user(bolt_sips_conn)
    # Missing cards as it will be created by controller call!!!
    dyed_roving = create_dyed_roving(bolt_sips_conn)
    dyes_user = create_user(bolt_sips_conn)
    create_dyes(bolt_sips_conn, %{dyed_roving_id: dyed_roving.id, user_id: dyes_user.id})
    create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: roving.id})
    create_material_for(bolt_sips_conn, %{start_node_id: roving.id, end_node_id: dyed_roving.id})
    yarn = create_yarn(bolt_sips_conn)
    spins_user = create_user(bolt_sips_conn)
    create_spins(bolt_sips_conn, %{yarn_id: yarn.id, user_id: spins_user.id})
    create_material_for(bolt_sips_conn, %{start_node_id: dyed_roving.id, end_node_id: yarn.id})
    project = create_project(bolt_sips_conn)
    knits_user = create_user(bolt_sips_conn)
    create_knits(bolt_sips_conn, %{project_id: project.id, user_id: knits_user.id})

    socket = socket("user_id", %{})
    {:ok, _, _} = subscribe_and_join(socket, ElixirRavelryWeb.GraphChannel, "graph:#{project.id}")

    conn = post conn, "/api/v1/material-for", %{start_node_id: yarn.id, end_node_id: project.id}
    assert json_response(conn, 201)

    topic = "graph:#{project.id}"
    assert_receive %Phoenix.Socket.Message{
      event: "graph_update",
      topic: ^topic,
      payload: %{
        nodes: first_nodes,
        relationships: _first_relationships
      }
    }
    refute cards_user in first_nodes

    conn =
      conn
      |> recycle()
      |> Plug.Conn.put_private(:bolt_sips_conn, bolt_sips_conn)
      |> post("/api/v1/cards", %{user_id: cards_user.id, roving_id: roving.id})

    assert json_response(conn, 201)

    assert_receive %Phoenix.Socket.Message{
      event: "graph_update",
      topic: ^topic,
      payload: %{
        nodes: second_nodes,
        relationships: second_relationships
      }
    }
    assert length(second_nodes) == 1
    assert cards_user in second_nodes
    assert length(second_relationships) == 1
    end
end
