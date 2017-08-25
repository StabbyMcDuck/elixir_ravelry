defmodule ElixirRavelryWeb.MaterialFor do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{Wool, Carding}

  schema "material_for" do
    belongs_to :wool, Wool
    belongs_to :carding, Carding
  end

  defimpl Poison.Encoder do
    def encode(%{id: id, carding_id: carding_id, wool_id: wool_id}, options) do
      Poison.Encoder.Map.encode(%{id: id, carding_id: carding_id, wool_id: wool_id}, options)
    end
  end

end