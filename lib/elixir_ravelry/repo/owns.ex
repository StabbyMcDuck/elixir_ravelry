defmodule ElixirRavelry.Repo.Owns do
  @moduledoc false

  alias ElixirRavelryWeb.Owns
  alias ElixirRavelry.Repo

  def create(conn, %Owns{started_at: started_at, user_id: user_id, wool_id: wool_id}) do
    Repo.create_relationship(conn, %{type: "OWNS", end_node_id: wool_id, start_node_id: user_id, started_at: Repo.to_timestamp(started_at)})
  end

  def get(conn, id) do
    Repo.get_relationship(conn, "OWNS", id)
  end

  def list(conn) do
    Repo.list_relationship(conn, "OWNS")
  end

  def return_to_owns_list(return) when is_list(return) do
    Enum.map(return, &return_to_owns/1)
  end

  def return_to_owns(%{"r" => relationship}) do
    row_to_struct(relationship)
  end

  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": wool_id, id: id, properties: %{"started_at" => started_at_timestamp}, start: user_id, type: "OWNS"}) do
    %Owns{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Owns"},
        state: :loaded
      },
      id: id,
      wool_id: wool_id,
      user_id: user_id,
      started_at: Repo.from_timestamp(started_at_timestamp)
    }
  end
end