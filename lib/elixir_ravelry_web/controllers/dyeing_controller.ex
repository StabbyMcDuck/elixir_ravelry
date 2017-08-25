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
end

