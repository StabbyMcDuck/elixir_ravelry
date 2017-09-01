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