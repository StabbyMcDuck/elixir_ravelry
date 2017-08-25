defmodule ElixirRavelry.CardingCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Carding

  def create_carding(bolt_sips_conn) do
    Repo.Carding.create(bolt_sips_conn, %Carding{name: Faker.Name.name()})
  end
end