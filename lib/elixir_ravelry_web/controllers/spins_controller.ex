defmodule ElixirRavelryWeb.SpinsController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    spins = conn
           |> bolt_sips_conn()
           |> Repo.Spins.list()
    json conn, spins
  end

  def show(conn, %{"id" => id}) do
    conn
    |> bolt_sips_conn()
    |> Repo.Spins.get(id)
    |> case do
         {:ok, spins} -> json conn, spins
         :error -> not_found(conn)
       end
  end
end

