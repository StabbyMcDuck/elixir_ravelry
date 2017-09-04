defmodule ElixirRavelryWeb.ProjectController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    project = conn
            |> bolt_sips_conn()
            |> Repo.Project.list()
    json conn, project
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.Project.get(id)
      |> case do
           {:ok, project} -> json conn, project
                          :error -> not_found(conn)
         end
  end

  def graph(conn, params = %{"project_id" => id}) do
    direction = Map.get(params, "direction", "both")
    options = case params do
      %{"type" => type} when is_binary(type) -> %{type: type}
      _ -> %{}
    end
    conn
    |> bolt_sips_conn()
    |> Repo.Project.graph(id, direction, options)
    |> case do
         {:ok, graph} -> json conn, graph
         :error -> not_found(conn)
       end
  end
end

