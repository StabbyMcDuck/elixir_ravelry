defmodule ElixirRavelryWeb.User do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.Owns

  schema "users" do
    field :name, :string

    has_many :owns, Owns
  end

  defimpl Poison.Encoder do
    def encode(%{name: name, id: id}, options) do
      Poison.Encoder.Map.encode(%{name: name, id: id, type: "User"}, options)
    end
  end
end