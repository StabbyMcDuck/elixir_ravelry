defmodule ElixirRavelry.CardsCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Cards

  def create_cards(bolt_sips_conn, %{roving_id: roving_id, user_id: user_id}) do
    {:ok, card} = Repo.Cards.create(bolt_sips_conn, %Cards{user_id: user_id, roving_id: roving_id})
    card
  end
end