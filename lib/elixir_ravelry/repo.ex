defmodule ElixirRavelry.Repo do
  @moduledoc false

  alias ElixirRavelryWeb.{User, Wool, Owns}

  def create_user(conn, %User{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (u:User {name: {name}})
         RETURN u
         """,
         %{name: name}
       )
    |> return_to_users()
    |> hd()
  end

  def create_wool(conn, %Wool{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (w:Wool {name: {name}})
         RETURN w
         """,
         %{name: name}
       )
    |> return_to_wool_list()
    |> hd()
  end

  def create_owns(conn, %Owns{started_at: started_at, user_id: user_id, wool_id: wool_id}) do
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

  def return_to_users(return) when is_list(return) do
    Enum.map(return, &return_to_user/1)
  end

  def return_to_wool_list(return) when is_list(return) do
    Enum.map(return, &return_to_wool/1)
  end

  def return_to_owns_list(return) when is_list(return) do
    Enum.map(return, &return_to_owns/1)
  end

  def return_to_user(
        %{
          "u" => %Bolt.Sips.Types.Node{
            id: id,
            labels: ["User"],
            properties: %{
              "name" => name
            }
          }
        }
      ) do
    %User{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "User"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end

  def return_to_wool(
        %{
          "w" => %Bolt.Sips.Types.Node{
            id: id,
            labels: ["Wool"],
            properties: %{
              "name" => name
            }
          }
        }
      ) do
    %Wool{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Wool"},
        state: :loaded
      },
      id: id,
      name: name
    }
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

  def list_users(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User)
         RETURN u
         """
       )
    |> return_to_users()
  end

  def get_user(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User)
         WHERE id(u) = toInteger({id})
         RETURN u
         """,
         %{id: id}
       )
    |> return_to_users()
    |> case do
         [] -> :error
         [user] -> {:ok, user}
       end
  end

  def list_wool(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (w:Wool)
         RETURN w
         """
       )
    |> return_to_wool_list()
  end

  def get_wool(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (w:Wool)
         WHERE id(w) = toInteger({id})
         RETURN w
         """,
         %{id: id}
       )
    |> return_to_wool_list()
    |> case do
         [] -> :error
         [wool] -> {:ok, wool}
       end
  end

  def list_owns(conn) do
    conn
    |> Bolt.Sips.query!(
        """
        MATCH (u:User)-[o:OWNS]->(w:Wool)
        RETURN o
        """
       )
    |> return_to_owns_list()
  end

  def get_owns(conn, id) do
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

  def row_to_struct(relationship = %Bolt.Sips.Types.Relationship{type: type}) do
    repo_schema_module = type_to_repo_module(type)
    repo_schema_module.row_to_struct(relationship)
  end

  def row_to_struct(node = %Bolt.Sips.Types.Node{labels: [type | _]}) do
    repo_schema_module = type_to_repo_module(type)
    repo_schema_module.row_to_struct(node)
  end

  def type_to_repo_module("MATERIAL_FOR") do
    __MODULE__.MaterialFor
  end

  def type_to_repo_module(type) do
    Module.concat([__MODULE__, type])
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