defmodule ElixirRavelryWeb.Owns do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{User, Wool}

  schema "owns" do
    field :started_at, :utc_datetime

    belongs_to :user, User
    belongs_to :wool, Wool
  end

  defimpl Poison.Encoder do
    def encode(%{id: id, wool_id: wool_id, user_id: user_id, started_at: started_at}, options) do
      Poison.Encoder.Map.encode(%{id: id, wool_id: wool_id, user_id: user_id, started_at: started_at}, options)
    end
  end

end