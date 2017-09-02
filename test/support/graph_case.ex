defmodule ElixirRavelry.GraphCase do
  import ElixirRavelry.{CardsCase, DyedRovingCase, DyesCase, KnitsCase, MaterialForCase, ProjectCase, RovingCase,
                        SpinsCase, UserCase, WoolCase, YarnCase}

  def create_connected_project(bolt_sips_conn) do
    wool = create_wool(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)
    cards_user = create_user(bolt_sips_conn)
    cards = create_cards(bolt_sips_conn, %{roving_id: roving.id, user_id: cards_user.id})
    dyed_roving = create_dyed_roving(bolt_sips_conn)
    dyes_user = create_user(bolt_sips_conn)
    dyes = create_dyes(bolt_sips_conn, %{dyed_roving_id: dyed_roving.id, user_id: dyes_user.id})
    wool_material_for_roving = create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: roving.id})
    roving_material_for_dyed_roving = create_material_for(bolt_sips_conn, %{start_node_id: roving.id, end_node_id: dyed_roving.id})
    yarn = create_yarn(bolt_sips_conn)
    spins_user = create_user(bolt_sips_conn)
    spins = create_spins(bolt_sips_conn, %{yarn_id: yarn.id, user_id: spins_user.id})
    dyed_roving_material_for_yarn = create_material_for(bolt_sips_conn, %{start_node_id: dyed_roving.id, end_node_id: yarn.id})
    project = create_project(bolt_sips_conn)
    knits_user = create_user(bolt_sips_conn)
    knits = create_knits(bolt_sips_conn, %{project_id: project.id, user_id: knits_user.id})
    yarn_material_for_project = create_material_for(bolt_sips_conn, %{start_node_id: yarn.id, end_node_id: project.id})

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
    }
  end
end