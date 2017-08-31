defmodule ElixirRavelryWeb.RovingController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    roving = conn
            |> bolt_sips_conn()
            |> Repo.Roving.list()
    json conn, roving
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.Roving.get(id)
      |> case do
           {:ok, roving} -> json conn, roving
                          :error -> not_found(conn)
         end
  end
end

