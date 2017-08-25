defmodule ElixirRavelryWeb.CardsController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

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

