defmodule ElixirRavelryWeb.MaterialForController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.{Graph, MaterialFor}

  def create(conn, params) do
    changeset = MaterialFor.changeset(%MaterialFor{}, params)

    if changeset.valid? do
      material_for = Ecto.Changeset.apply_changes(changeset)

      conn
      |> bolt_sips_conn()
      |> Graph.create_relationship(material_for, material_for.end_node_id)
      |> case do
           {:ok, created} ->
             conn
             |> put_status(:created)
             |> json(created)
           :error ->
             conn
             |> put_status(:unprocessable_entity)
             |> json(%{})
         end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(changeset)
    end
  end

  def index(conn, _params) do
    material_for = conn
           |> bolt_sips_conn()
           |> Repo.MaterialFor.list()
    json conn, material_for
  end

  def show(conn, %{"id" => id}) do
    conn
    |> bolt_sips_conn()
    |> Repo.MaterialFor.get(id)
    |> case do
         {:ok, material_for} -> json conn, material_for
         :error -> not_found(conn)
       end
  end
end

