defmodule ElixirRavelry.Repo.MaterialFor do
  @moduledoc false

  alias ElixirRavelryWeb.{MaterialFor}
  alias ElixirRavelry.Repo

  def create(conn, %MaterialFor{end_node_id: end_node_id, start_node_id: start_node_id}) do
    Repo.create_relationship(conn, %{type: "MATERIAL_FOR", end_node_id: end_node_id, start_node_id: start_node_id})
  end

  def get(conn, id) do
    Repo.get_relationship(conn, "MATERIAL_FOR", id)
  end

  def list(conn) do
    Repo.list_relationship(conn, "MATERIAL_FOR")
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