defmodule ElixirRavelryWeb.CardsController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.{Cards, Graph}

  def create(conn, params) do
    changeset = Cards.changeset(%Cards{}, params)

    if changeset.valid? do
      cards = Ecto.Changeset.apply_changes(changeset)

      conn
      |> bolt_sips_conn()
      |> Graph.create_relationship(cards, cards.roving_id)
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
    cards = conn
           |> bolt_sips_conn()
           |> Repo.Cards.list()
    json conn, cards
  end

  def show(conn, %{"id" => id}) do
    conn
    |> bolt_sips_conn()
    |> Repo.Cards.get(id)
    |> case do
         {:ok, cards} -> json conn, cards
         :error -> not_found(conn)
       end
  end
end

