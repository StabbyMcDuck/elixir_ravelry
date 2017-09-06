defmodule ElixirRavelryWeb.Graph do
  @moduledoc false

  def create_relationship(conn, data = %data_type{}, node_id) do
    relationship_suffix = data_type
             |> Module.split()
             |> List.last()


    relationship_repo_module = Module.concat(ElixirRavelry.Repo, relationship_suffix)

    with ok = {:ok, _created} <- relationship_repo_module.create(conn, data) do
      {:ok, graph = %{nodes: nodes}} = ElixirRavelry.Repo.graph(conn, node_id, "both", %{})
      Enum.each(nodes, &notify_graph(&1, graph))

      ok
    end
  end

  defp notify_graph(%{id: id}, graph) do
    ElixirRavelryWeb.Endpoint.broadcast! "graph:#{id}", "graph_update", graph
  end
end