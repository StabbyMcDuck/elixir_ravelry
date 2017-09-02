defmodule ElixirRavelry.ProjectCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Project

  def create_project(bolt_sips_conn) do
    Repo.Project.create(bolt_sips_conn, %Project{name: Faker.Name.name()})
  end


end