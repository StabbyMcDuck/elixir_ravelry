defmodule ElixirRavelry.YarnCase do
  import ElixirRavelry.{RovingCase, MaterialForCase, WoolCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Yarn

  def create_yarn(bolt_sips_conn) do
    Repo.Yarn.create(bolt_sips_conn, %Yarn{name: Faker.Name.name()})
  end

  def create_connected_yarn(bolt_sips_conn) do
    wool = create_wool(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)

    wool_material_for_roving = create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: roving.id})

    yarn = create_yarn(bolt_sips_conn)

    roving_material_for_yarn = create_material_for(bolt_sips_conn, %{start_node_id: roving.id, end_node_id: yarn.id})

    %{roving: roving, roving_material_for_yarn: roving_material_for_yarn, yarn: yarn, wool: wool, wool_material_for_roving: wool_material_for_roving}
  end
end