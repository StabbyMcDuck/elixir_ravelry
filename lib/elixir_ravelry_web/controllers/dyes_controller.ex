defmodule ElixirRavelryWeb.DyesController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    dyes = conn
           |> bolt_sips_conn()
           |> Repo.Dyes.list()
    json conn, dyes
  end

  def show(conn, %{"id" => id}) do
    conn
    |> bolt_sips_conn()
    |> Repo.Dyes.get(id)
    |> case do
         {:ok, dyes} -> json conn, dyes
         :error -> not_found(conn)
       end
  end
end

