defmodule ElixirRavelry.DyeingCase do
  import ElixirRavelry.{CardingCase, MaterialForCase, WoolCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Dyeing

  def create_dyeing(bolt_sips_conn) do
    Repo.Dyeing.create(bolt_sips_conn, %Dyeing{name: Faker.Name.name()})
  end

  def create_connected_dyeing(bolt_sips_conn) do
    wool = create_wool(bolt_sips_conn)
    carding = create_carding(bolt_sips_conn)

    wool_material_for_carding = create_material_for(bolt_sips_conn, %{start_node_id: wool.id, end_node_id: carding.id})

    dyeing = create_dyeing(bolt_sips_conn)

    carding_material_for_dyeing = create_material_for(bolt_sips_conn, %{start_node_id: carding.id, end_node_id: dyeing.id})

    %{carding: carding, carding_material_for_dyeing: carding_material_for_dyeing, dyeing: dyeing, wool: wool, wool_material_for_carding: wool_material_for_carding}
  end
end