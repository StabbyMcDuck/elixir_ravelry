defmodule ElixirRavelry.CardsCase do
  import ElixirRavelry.{CardingCase, UserCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Cards

  def create_cards(bolt_sips_conn) do
    user = create_user(bolt_sips_conn)
    carding = create_carding(bolt_sips_conn)
    Repo.Cards.create(bolt_sips_conn, %Cards{user_id: user.id, carding_id: carding.id})
  end
end