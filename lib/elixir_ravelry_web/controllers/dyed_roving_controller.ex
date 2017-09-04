defmodule ElixirRavelryWeb.DyedRovingController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    dyed_roving = conn
            |> bolt_sips_conn()
            |> Repo.DyedRoving.list()
    json conn, dyed_roving
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.DyedRoving.get(id)
      |> case do
           {:ok, dyed_roving} -> json conn, dyed_roving
                          :error -> not_found(conn)
         end
  end

  def graph(conn, params = %{"dyed_roving_id"=>id}) do
    direction = Map.get(params, "direction", "both")
    options = case params do
      %{"type" => type} when is_binary(type) -> %{type: type}
      _ -> %{}
    end
    conn
    |> bolt_sips_conn()
    |> Repo.DyedRoving.graph(id, direction, options)
    |> case do
         {:ok, graph} -> json conn, graph
         :error -> not_found(conn)
       end
  end
end

