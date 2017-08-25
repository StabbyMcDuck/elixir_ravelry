defmodule ElixirRavelryWeb.Dyeing do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{Owns, Material, Dyes}

  schema "dyeing" do
    field :name, :string

    has_one :dyes, Dyes
    has_one :owns, Owns

    has_many :material, Material_for
  end

  defimpl Poison.Encoder do
    def encode(%{name: name, id: id}, options) do
      Poison.Encoder.Map.encode(%{name: name, id: id}, options)
    end
  end
end