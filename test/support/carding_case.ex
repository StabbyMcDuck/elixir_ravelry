defmodule ElixirRavelry.RovingCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Roving

  def create_roving(bolt_sips_conn) do
    Repo.Roving.create(bolt_sips_conn, %Roving{name: Faker.Name.name()})
  end
end