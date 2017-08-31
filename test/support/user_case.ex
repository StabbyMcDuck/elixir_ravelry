defmodule ElixirRavelry.UserCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.User

  def create_user(bolt_sips_conn) do
    Repo.User.create(bolt_sips_conn, %User{name: Faker.Name.name()})
  end

end