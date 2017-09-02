defmodule ElixirRavelryWeb.Cards do
    use ElixirRavelryWeb, :model

    alias ElixirRavelryWeb.{User, Roving}

    schema "cards" do
      belongs_to :user, User
      belongs_to :roving, Roving
    end

    defimpl Poison.Encoder do
      def encode(%{id: id, roving_id: roving_id, user_id: user_id}, options) do
        Poison.Encoder.Map.encode(%{id: id, roving_id: roving_id, user_id: user_id, type: "Cards"}, options)
      end
    end

  end