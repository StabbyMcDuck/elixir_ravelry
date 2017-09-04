defmodule ElixirRavelryWeb.YarnController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    yarn = conn
            |> bolt_sips_conn()
            |> Repo.Yarn.list()
    json conn, yarn
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.Yarn.get(id)
      |> case do
           {:ok, yarn} -> json conn, yarn
                          :error -> not_found(conn)
         end
  end

  def graph(conn, params = %{"yarn_id"=>id}) do
    direction = Map.get(params, "direction", "both")
    options = case params do
      %{"type" => type} when is_binary(type) -> %{type: type}
      _ -> %{}
    end
    conn
    |> bolt_sips_conn()
    |> Repo.Yarn.graph(id, direction, options)
    |> case do
         {:ok, graph} -> json conn, graph
         :error -> not_found(conn)
       end
  end
end

