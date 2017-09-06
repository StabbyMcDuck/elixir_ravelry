defmodule ElixirRavelryWeb.CardsController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.{Cards, Graph}

  def create(conn, params) do
    changeset = Cards.changeset(%Cards{}, params)

    if changeset.valid? do
      cards = Ecto.Changeset.apply_changes(changeset)
      created =
        conn
        |> bolt_sips_conn()
        |> Graph.create_relationship(cards, Roving, cards.roving_id)

      conn
      |> put_status(:created)
      |> json(created)

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

