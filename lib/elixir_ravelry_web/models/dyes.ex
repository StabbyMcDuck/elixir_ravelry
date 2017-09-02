defmodule ElixirRavelryWeb.Dyes do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{User, DyedRoving}

  schema "DYES" do
    belongs_to :user, User
    belongs_to :dyed_roving, DyedRoving
  end

  defimpl Poison.Encoder do
    def encode(%{id: id, dyed_roving_id: dyed_roving_id, user_id: user_id}, options) do
      Poison.Encoder.Map.encode(%{id: id, dyed_roving_id: dyed_roving_id, user_id: user_id}, options)
    end
  end

end