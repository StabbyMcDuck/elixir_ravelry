defmodule ElixirRavelryWeb.CardingController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    carding = conn
            |> bolt_sips_conn()
            |> Repo.Carding.list()
    json conn, carding
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.Carding.get(id)
      |> case do
           {:ok, carding} -> json conn, carding
                          :error -> not_found(conn)
         end
  end
end

