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

  def return_to_cards_list(return) when is_list(return) do
    Enum.map(return, &return_to_cards/1)
  end

  def return_to_cards(%{"r" => relationship}) do
    row_to_struct(relationship)
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