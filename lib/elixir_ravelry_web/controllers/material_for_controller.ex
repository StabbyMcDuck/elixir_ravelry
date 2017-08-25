defmodule ElixirRavelryWeb.Material_forController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    material_for = conn
           |> bolt_sips_conn()
           |> Repo.Material_for.list()
    json conn, material_for
  end

  def show(conn, %{"id" => id}) do
    conn
    |> bolt_sips_conn()
    |> Repo.Material_for.get(id)
    |> case do
         {:ok, material_for} -> json conn, material_for
         :error -> not_found(conn)
       end
  end
end

