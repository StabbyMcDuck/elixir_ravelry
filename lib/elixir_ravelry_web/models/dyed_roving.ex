defmodule ElixirRavelryWeb.DyedRoving do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{Owns, MaterialFor, Dyes}

  schema "dyed_roving" do
    field :name, :string

    has_one :dyes, Dyes
    has_one :owns, Owns

    has_many :material_for_end, MaterialFor, foreign_key: :end_node_id
    has_many :material_for_start, MaterialFor, foreign_key: :start_node_id
  end

  defimpl Poison.Encoder do
    def encode(%{name: name, id: id}, options) do
      Poison.Encoder.Map.encode(%{name: name, id: id, type: "DyedRoving"}, options)
    end
  end
end