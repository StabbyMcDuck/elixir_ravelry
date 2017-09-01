defmodule ElixirRavelry.Repo do
  @moduledoc false

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

  def type_to_repo_module("OWNS") do
    __MODULE__.Owns
  end

  def type_to_repo_module("CARDS") do
    __MODULE__.Cards
  end

  def type_to_repo_module(type) do
    Module.concat([__MODULE__, type])
  end

  def create_relationship(conn, options = %{type: type}) do
    query_options = Map.delete(options, :type)
    properties = Map.drop(query_options, [:end_node_id, :start_node_id])
    property_cypher = property_cypher(properties)
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (e) WHERE id(e) = {end_node_id}
         MATCH (s) WHERE id(s) = {start_node_id}
         CREATE (s)-[r:#{type}#{property_cypher}]->(e)
         RETURN r
         """,
         query_options
       )
    |> return_to_list()
    |> hd()
  end

  defp property_cypher(properties) do
    property_cypher_fields = Enum.map_join(properties, ", ", fn {key, _} ->
      "#{key}: {#{key}}"
    end)
    "{#{property_cypher_fields}}"
  end

  def create_node(conn, options = %{type: type}) do
    query_options = Map.delete(options, :type)
    property_cypher = property_cypher(query_options)
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (n:#{type}#{property_cypher})
         RETURN n
         """,
         query_options
       )
    |> return_to_list()
    |> hd()
  end

  def get_node(conn, type, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (n:#{type})
         WHERE id(n) = toInteger({id})
         RETURN n
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [node] -> {:ok, node}
       end
  end

  def get_relationship(conn, type, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH ()-[r:#{type}]->()
         WHERE id(r) = toInteger({id})
         RETURN r
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [relationship] -> {:ok, relationship}
       end
  end

  def list_relationship(conn, type) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH ()-[r:#{type}]->()
         RETURN r
         """
       )
    |> return_to_list()
  end

  def list_node(conn, type) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (n:#{type})
         RETURN n
         """
       )
    |> return_to_list()
  end

  defp return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_struct/1)
  end

  defp return_to_struct(
        %{
          "n" => node
        }
      ) do
    row_to_struct(node)
  end

  defp return_to_struct(
         %{
           "r" => relationship
         }
       ) do
    row_to_struct(relationship)
  end

  #code from http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html
  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def from_timestamp(timestamp) do
    timestamp
    |> Kernel.+(@epoch)
    |> :calendar.gregorian_seconds_to_datetime()
    |> Ecto.DateTime.from_erl()
  end

  def to_timestamp(datetime) do
    datetime
    |> Ecto.DateTime.to_erl()
    |> :calendar.datetime_to_gregorian_seconds()
    |> Kernel.-(@epoch)
  end
end