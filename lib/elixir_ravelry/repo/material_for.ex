defmodule ElixirRavelry.Repo.MaterialFor do
  @moduledoc false

  alias ElixirRavelryWeb.MaterialFor
  alias ElixirRavelry.Repo

  # Macros

  @impl ElixirRavelry.Repo.Relationship
  defmacro type, do: "MATERIAL_FOR"
  use ElixirRavelry.Repo.Relationship

  #Functions

  @impl ElixirRavelry.Repo.Relationship
  def create(conn, %MaterialFor{end_node_id: end_node_id, start_node_id: start_node_id}) do
    Repo.create_relationship(conn, %{type: type(), end_node_id: end_node_id, start_node_id: start_node_id})
  end

  @impl ElixirRavelry.Repo.Relationship
  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": end_node_id, id: id, start: start_node_id, type: type()}) do
    %MaterialFor{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      start_node_id: start_node_id,
      end_node_id: end_node_id
    }
  end
end