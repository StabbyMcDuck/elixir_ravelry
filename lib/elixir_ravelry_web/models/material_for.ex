defmodule ElixirRavelryWeb.MaterialFor do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.Node

  schema "material_for" do
    belongs_to :end_node, Node
    belongs_to :start_node, Node
  end

  defimpl Poison.Encoder do
    def encode(%{id: id, end_node_id: end_node_id, start_node_id: start_node_id}, options) do
      Poison.Encoder.Map.encode(%{id: id, end_node_id: end_node_id, start_node_id: start_node_id, type: "MaterialFor"}, options)
    end
  end

end