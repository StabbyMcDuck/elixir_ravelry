defmodule ElixirRavelryWeb.Wool do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.Owns

  schema "wool" do
    field :name, :string

    has_one :owns, Owns
  end

  defimpl Poison.Encoder do
    def encode(%{name: name, id: id}, options) do
      Poison.Encoder.Map.encode(%{name: name, id: id, type: "Wool"}, options)
    end
  end
end