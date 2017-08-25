defmodule ElixirRavelry.Material_forCase do
  import ElixirRavelry.{CardingCase, WoolCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Material_for

  def create_material_for(bolt_sips_conn) do
    wool = create_wool(bolt_sips_conn)
    carding = create_carding(bolt_sips_conn)
    Repo.Material_for.create(bolt_sips_conn, %Material_for{wool_id: wool.id, carding_id: carding.id})
  end
end