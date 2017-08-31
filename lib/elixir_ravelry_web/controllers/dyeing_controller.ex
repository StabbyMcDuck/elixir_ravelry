defmodule ElixirRavelryWeb.DyeingController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    dyeing = conn
            |> bolt_sips_conn()
            |> Repo.Dyeing.list()
    json conn, dyeing
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.Dyeing.get(id)
      |> case do
           {:ok, dyeing} -> json conn, dyeing
                          :error -> not_found(conn)
         end
  end

  def graph(conn, params = %{"dyeing_id"=>id}) do
    direction = Map.get(params, "direction", "both")
    conn
    |> bolt_sips_conn()
    |> Repo.Dyeing.graph(id, direction)
    |> case do
         {:ok, graph} -> json conn, graph
         :error -> not_found(conn)
       end
  end
end

