defmodule ElixirRavelry.CardsCase do
  import ElixirRavelry.{RovingCase, UserCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Cards

  def create_cards(bolt_sips_conn) do
    user = create_user(bolt_sips_conn)
    roving = create_roving(bolt_sips_conn)
    Repo.Cards.create(bolt_sips_conn, %Cards{user_id: user.id, roving_id: roving.id})
  end
end