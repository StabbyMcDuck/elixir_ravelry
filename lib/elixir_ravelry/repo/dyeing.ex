defmodule ElixirRavelry.Repo.Dyeing do
  @moduledoc false

  alias ElixirRavelryWeb.Dyeing
  alias ElixirRavelry.Repo

  def create(conn, %Dyeing{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (d:Dyeing {name: {name}})
         RETURN d
         """,
         %{name: name}
       )
    |> return_to_list()
    |> hd()
  end

  def get(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (d:Dyeing)
         WHERE id(d) = toInteger({id})
         RETURN d
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [dyeing] -> {:ok, dyeing}
       end
  end

  defp backwards_optional_match(direction) when direction in ~w(backwards both) do
    """
    OPTIONAL MATCH backwards = (source)-[backwards_relationship*0..]->(d)
    """
  end

  defp backwards_optional_match("forward") do
    ""
  end

  defp forward_optional_match(direction) when direction in ~w(forward both) do
    """
    OPTIONAL MATCH forward = (d)-[forward_relationship*0..]->(sink)
    """
  end

  defp forward_optional_match("backwards") do
    ""
  end

  defp graph_return("backwards") do
    "source_nodes, backwards_rels"
  end

  defp graph_return("both") do
    "#{graph_return("forward")}, #{graph_return("backwards")}"
  end

  defp graph_return("forward") do
    "sink_nodes, forward_rels"
  end

  defp graph_with("backwards") do
    """
    collect(DISTINCT source) as source_nodes,
    collect(DISTINCT head(backwards_relationship)) as backwards_rels
    """
  end

  defp graph_with("both") do
    "#{graph_with("forward")}, #{graph_with("backwards")}"
  end

  defp graph_with("forward") do
    """
    collect(DISTINCT sink) as sink_nodes,
    collect(DISTINCT last(forward_relationship)) as forward_rels
    """
  end

  defp graph_unwind("backwards") do
    """
    UNWIND backwards_nodes AS backwards_node
    UNWIND backwards_rels AS backwards_rel
    """
  end

  defp graph_unwind("both") do
    """
    #{graph_unwind("backwards")}
    #{graph_unwind("forward")}
    """
  end

  defp graph_unwind("forward") do
    """
    UNWIND forward_nodes AS forward_node
    UNWIND forward_rels AS forward_rel
    """
  end

  def graph(conn, id, direction) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (d:Dyeing)
         WHERE id(d) = toInteger({id})
         #{backwards_optional_match(direction)}
         #{forward_optional_match(direction)}
         WITH #{graph_with(direction)}
         RETURN #{graph_return(direction)}
         """,
         %{id: id}
       )
    |> graph_return_to_list()
  end

  def graph_return_to_list([map]) when is_map(map) do
    map
    |> Enum.flat_map(
      fn {_, value} when is_list(value) ->
        Enum.map(value, &Repo.row_to_struct/1)
      end
    )
    |> case do
        [] -> :error
        list -> {:ok, list}
       end
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (d:Dyeing)
         RETURN d
         """
       )
    |> return_to_list()
  end

  def return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_dyeing/1)
  end

  def return_to_dyeing(
        %{
          "d" => node
        }
      ) do
    row_to_struct(node)
  end

  def row_to_struct(
        %Bolt.Sips.Types.Node{
          id: id,
          labels: ["Dyeing"],
          properties: %{
            "name" => name
          }
        }
      ) do
    %Dyeing{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Dyeing"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end