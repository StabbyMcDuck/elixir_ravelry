defmodule ElixirRavelry.Repo.Owns do
  @moduledoc false

  alias ElixirRavelryWeb.{User, Wool, Owns}

  def create(conn, %Owns{started_at: started_at, user_id: user_id, wool_id: wool_id}) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User) WHERE id(u) = {user_id}
         MATCH (w:Wool) WHERE id(w) = {wool_id}
         CREATE (u)-[o:OWNS{started_at: {started_at}}]->(w)
         RETURN o
         """,
         %{started_at: to_timestamp(started_at), user_id: user_id, wool_id: wool_id}
       )
    |> return_to_owns_list()
    |> hd()
  end

  def get(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User)-[o:OWNS]->(w:Wool)
         WHERE id(o) = toInteger({id})
         RETURN o
         """,
         %{id: id}
       )
    |> return_to_owns_list()
    |> case do
         [] -> :error
         [owns] -> {:ok, owns}
       end
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User)-[o:OWNS]->(w:Wool)
         RETURN o
         """
       )
    |> return_to_owns_list()
  end

  def return_to_owns_list(return) when is_list(return) do
    Enum.map(return, &return_to_owns/1)
  end

  def return_to_owns(%{"o" => %Bolt.Sips.Types.Relationship{"end": wool_id, id: id, properties: %{"started_at" => started_at_timestamp}, start: user_id, type: "OWNS"}}) do
    %Owns{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Owns"},
        state: :loaded
      },
      id: id,
      wool_id: wool_id,
      user_id: user_id,
      started_at: from_timestamp(started_at_timestamp)
    }
  end

  ## Private Functions

  #code from http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html
  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def from_timestamp(timestamp) do
    timestamp
    |> +(@epoch)
    |> :calendar.gregorian_seconds_to_datetime()
    |> Ecto.DateTime.from_erl()
  end

  def to_timestamp(datetime) do
    datetime
    |> Ecto.DateTime.to_erl()
    |> :calendar.datetime_to_gregorian_seconds()
    |> -(@epoch)
  end
end