defmodule ElixirRavelry.DyeingCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Dyeing

  def create_dyeing(bolt_sips_conn) do
    Repo.Dyeing.create(bolt_sips_conn, %Dyeing{name: Faker.Name.name()})
  end
end