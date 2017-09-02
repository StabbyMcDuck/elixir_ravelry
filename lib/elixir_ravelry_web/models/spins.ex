defmodule ElixirRavelryWeb.Spins do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{User, Yarn}

  schema "SPINS" do
    belongs_to :user, User
    belongs_to :yarn, Yarn
  end

  defimpl Poison.Encoder do
    def encode(%{id: id, yarn_id: yarn_id, user_id: user_id}, options) do
      Poison.Encoder.Map.encode(%{id: id, yarn_id: yarn_id, user_id: user_id, type: "Spins"}, options)
    end
  end
end