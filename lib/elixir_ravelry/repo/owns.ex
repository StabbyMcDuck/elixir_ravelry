defmodule ElixirRavelry.Repo.Owns do
  @moduledoc false

  alias ElixirRavelryWeb.Owns
  alias ElixirRavelry.Repo

  def create(conn, %Owns{started_at: started_at, user_id: user_id, wool_id: wool_id}) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User) WHERE id(u) = {user_id}
         MATCH (w:Wool) WHERE id(w) = {wool_id}
         CREATE (u)-[r:OWNS{started_at: {started_at}}]->(w)
         RETURN r
         """,
         %{started_at: Repo.to_timestamp(started_at), user_id: user_id, wool_id: wool_id}
       )
    |> return_to_owns_list()
    |> hd()
  end

  def get(conn, id) do
    Repo.get_relationship(conn, "OWNS", id)
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User)-[r:OWNS]->(w:Wool)
         RETURN r
         """
       )
    |> return_to_owns_list()
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