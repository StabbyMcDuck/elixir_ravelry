defmodule ElixirRavelryWeb.Graph do
  @moduledoc false

  def create_relationship(conn, data = %data_type{}, node_module, node_id) do
    relationship_suffix = data_type
             |> Module.split()
             |> List.last()


    relationship_repo_module = Module.concat(ElixirRavelry.Repo, relationship_suffix)

    created = relationship_repo_module.create(conn, data)

    node_suffix = node_module
                  |> Module.split()
                  |> List.last()

    node_repo_module = Module.concat(ElixirRavelry.Repo, node_suffix)

    {:ok, graph = %{nodes: nodes}} = node_repo_module.graph(conn, node_id, "both", %{})
    Enum.each(nodes, &notify_graph(&1, graph))

    created
  end

  defp notify_graph(%{id: id}, graph) do
    ElixirRavelryWeb.Endpoint.broadcast! "graph:#{id}", "graph_update", graph
  end
end