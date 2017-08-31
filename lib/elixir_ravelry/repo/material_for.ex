defmodule ElixirRavelry.Repo.MaterialFor do
  @moduledoc false

  alias ElixirRavelryWeb.{MaterialFor}
  alias ElixirRavelry.Repo

  def create(conn, %MaterialFor{end_node_id: end_node_id, start_node_id: start_node_id}) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (e) WHERE id(e) = {end_node_id}
         MATCH (s) WHERE id(s) = {start_node_id}
         CREATE (s)-[r:MATERIAL_FOR]->(e)
         RETURN r
         """,
         %{end_node_id: end_node_id, start_node_id: start_node_id}
       )
    |> return_to_material_for_list()
    |> hd()
  end

  def get(conn, id) do
    Repo.get_relationship(conn, "MATERIAL_FOR", id)
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH ()-[r:MATERIAL_FOR]->()
         RETURN r
         """
       )
    |> return_to_material_for_list()
  end

  def return_to_material_for_list(return) when is_list(return) do
    Enum.map(return, &return_to_material_for/1)
  end

  def return_to_material_for(%{"r" => relationship}) do
    row_to_struct(relationship)
  end

  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": end_node_id, id: id, start: start_node_id, type: "MATERIAL_FOR"}) do
    %MaterialFor{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "MaterialFor"},
        state: :loaded
      },
      id: id,
      start_node_id: start_node_id,
      end_node_id: end_node_id
    }
  end
end