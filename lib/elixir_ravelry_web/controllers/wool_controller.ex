defmodule ElixirRavelryWeb.WoolController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    wool = conn
            |> bolt_sips_conn()
            |> Repo.Wool.list()
    json conn, wool
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.Wool.get(id)
      |> case do
           {:ok, wool} -> json conn, wool
                          :error -> not_found(conn)
         end
  end
end

