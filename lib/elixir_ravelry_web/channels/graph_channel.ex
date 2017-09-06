defmodule ElixirRavelryWeb.GraphChannel do
  use Phoenix.Channel
  intercept ["graph_update"]

  def join("graph:" <> _node_id, _params, socket) do
    graph_socket = socket
    |> assign(:node_id_set, MapSet.new())
    |> assign(:relationship_id_set, MapSet.new())

    {:ok, graph_socket}
  end

  def handle_out(event = "graph_update", %{nodes: nodes, relationships: relationships}, socket = %Phoenix.Socket{assigns: %{node_id_set: node_id_set, relationship_id_set: relationship_id_set}}) do
    new_node_id_set = to_id_set(nodes)
    new_relationship_id_set = to_id_set(relationships)

    difference_node_id_set = MapSet.difference(new_node_id_set, node_id_set)
    difference_relationship_id_set = MapSet.difference(new_relationship_id_set, relationship_id_set)

    filtered_nodes = Enum.filter(nodes, fn %{id: id} -> id in difference_node_id_set end)
    filtered_relationships = Enum.filter(relationships, fn %{id: id} -> id in difference_relationship_id_set end)
    filtered_graph = %{nodes: filtered_nodes, relationships: filtered_relationships}

    push socket, event, filtered_graph

    new_socket = socket
                 |> assign(:node_id_set, new_node_id_set)
                 |> assign(:relationship_id_set, new_relationship_id_set)

    {:noreply, new_socket}
  end

  defp to_id_set(list) when is_list(list) do
    Enum.into(list, MapSet.new, fn %{id: id} -> id end)
  end
end