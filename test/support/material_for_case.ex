defmodule ElixirRavelry.MaterialForCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.MaterialFor

  def create_material_for(bolt_sips_conn, %{end_node_id: end_node_id, start_node_id: start_node_id}) do
    Repo.MaterialFor.create(bolt_sips_conn, %MaterialFor{end_node_id: end_node_id, start_node_id: start_node_id})
  end
end