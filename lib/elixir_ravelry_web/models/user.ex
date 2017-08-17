defmodule ElixirRavelryWeb.User do
  use ElixirRavelryWeb, :model

  schema "users" do
    field :name, :string
  end

  defimpl Poison.Encoder do
    def encode(%{name: name, id: id}, options) do
      Poison.Encoder.Map.encode(%{name: name, id: id}, options)
    end
  end
end