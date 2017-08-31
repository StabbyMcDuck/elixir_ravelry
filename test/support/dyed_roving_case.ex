defmodule ElixirRavelry.DyedRovingCase do
  import ElixirRavelry.{RovingCase, MaterialForCase, WoolCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.DyedRoving

  def create_dyed_roving(bolt_sips_conn) do
    Repo.DyedRoving.create(bolt_sips_conn, %DyedRoving{name: Faker.Name.name()})
  end

  def create_connected_dyed_roving(bolt_sips_conn) do
    wool = create_wool(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)

    wool_material_for_roving = create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: roving.id})

    dyed_roving = create_dyed_roving(bolt_sips_conn)

    roving_material_for_dyed_roving = create_material_for(bolt_sips_conn, %{start_node_id: roving.id, end_node_id: dyed_roving.id})

    %{roving: roving, roving_material_for_dyed_roving: roving_material_for_dyed_roving, dyed_roving: dyed_roving, wool: wool, wool_material_for_roving: wool_material_for_roving}
  end
end