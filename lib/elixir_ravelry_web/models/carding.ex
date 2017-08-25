defmodule ElixirRavelryWeb.Carding do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{Owns, Material, Cards}

  schema "carding" do
    field :name, :string

    has_one :cards, Cards
    has_one :owns, Owns

    has_many :material, Material
  end

  defimpl Poison.Encoder do
    def encode(%{name: name, id: id}, options) do
      Poison.Encoder.Map.encode(%{name: name, id: id}, options)
    end
  end
end