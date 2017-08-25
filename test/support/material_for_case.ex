defmodule ElixirRavelry.MaterialForCase do
  import ElixirRavelry.{CardingCase, WoolCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.MaterialFor

  def create_material_for(bolt_sips_conn) do
    wool = create_wool(bolt_sips_conn)
    carding = create_carding(bolt_sips_conn)
    Repo.MaterialFor.create(bolt_sips_conn, %MaterialFor{wool_id: wool.id, carding_id: carding.id})
  end
end