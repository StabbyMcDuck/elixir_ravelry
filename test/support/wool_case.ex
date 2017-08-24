defmodule ElixirRavelry.WoolCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Wool

  def create_wool(bolt_sips_conn) do
    Repo.create_wool(bolt_sips_conn, %Wool{name: Faker.Name.name()})
  end
end