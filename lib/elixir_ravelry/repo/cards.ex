defmodule ElixirRavelry.Repo.Cards do
  @moduledoc false

  alias ElixirRavelryWeb.Cards
  alias ElixirRavelry.Repo

  def create(conn, %Cards{user_id: user_id, roving_id: roving_id}) do
    Repo.create_relationship(conn, %{type: "CARDS", end_node_id: roving_id, start_node_id: user_id})

  end

  def get(conn, id) do
    Repo.get_relationship(conn, "CARDS", id)
  end

  def list(conn) do
    Repo.list_relationship(conn, "CARDS")
  end

  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": roving_id, id: id, start: user_id, type: "CARDS"}) do
    %Cards{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Cards"},
        state: :loaded
      },
      id: id,
      roving_id: roving_id,
      user_id: user_id
    }
  end
end