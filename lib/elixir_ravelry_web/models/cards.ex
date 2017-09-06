defmodule ElixirRavelryWeb.Cards do
    use ElixirRavelryWeb, :model

    alias ElixirRavelryWeb.{User, Roving}

    @optional_fields []
    @required_fields [:user_id, :roving_id]
    @allowed_fields @optional_fields ++ @required_fields

    schema "cards" do
      belongs_to :user, User
      belongs_to :roving, Roving
    end

    def changeset(data, params) do
      data
      |> cast(params, @allowed_fields)
      |> validate_required(@required_fields)
    end

    defimpl Poison.Encoder do
      def encode(%{id: id, roving_id: roving_id, user_id: user_id}, options) do
        Poison.Encoder.Map.encode(%{id: id, roving_id: roving_id, user_id: user_id, type: "Cards"}, options)
      end
    end

  end