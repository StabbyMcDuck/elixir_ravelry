defmodule ElixirRavelryWeb.Cards do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{User, Carding}

  schema "cards" do
    belongs_to :user, User
    belongs_to :carding, Carding
  end

  defimpl Poison.Encoder do
    def encode(%{id: id, carding_id: carding_id, user_id: user_id}, options) do
      Poison.Encoder.Map.encode(%{id: id, carding_id: carding_id, user_id: user_id}, options)
    end
  end

end