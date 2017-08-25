defmodule ElixirRavelry.Repo.Cards do
  @moduledoc false

  alias ElixirRavelryWeb.{User, Cards}

  def create(conn, %Cards{user_id: user_id, carding_id: carding_id}) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User) WHERE id(u) = {user_id}
         MATCH (l:Carding) WHERE id(l) = {carding_id}
         CREATE (u)-[c:CARDS]->(l)
         RETURN c
         """,
         %{user_id: user_id, carding_id: carding_id}
       )
    |> return_to_cards_list()
    |> hd()
  end

  def get(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (:User)-[c:CARDS]->(:Carding)
         WHERE id(c) = toInteger({id})
         RETURN c
         """,
         %{id: id}
       )
    |> return_to_cards_list()
    |> case do
         [] -> :error
         [cards] -> {:ok, cards}
       end
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (:User)-[c:CARDS]->(:Carding)
         RETURN c
         """
       )
    |> return_to_cards_list()
  end

  def return_to_cards_list(return) when is_list(return) do
    Enum.map(return, &return_to_cards/1)
  end

  def return_to_cards(%{"c" => %Bolt.Sips.Types.Relationship{"end": carding_id, id: id, start: user_id, type: "CARDS"}}) do
    %Cards{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Cards"},
        state: :loaded
      },
      id: id,
      carding_id: carding_id,
      user_id: user_id
    }
  end
end