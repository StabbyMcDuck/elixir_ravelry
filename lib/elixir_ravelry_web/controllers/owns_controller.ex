defmodule ElixirRavelryWeb.OwnsController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    owns = conn
           |> bolt_sips_conn()
           |> Repo.Owns.list()
    json conn, owns
  end

  def show(conn, %{"id" => id}) do
    conn
    |> bolt_sips_conn()
    |> Repo.Owns.get(id)
    |> case do
         {:ok, owns} -> json conn, owns
         :error -> not_found(conn)
       end
  end
end

