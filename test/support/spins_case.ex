defmodule ElixirRavelry.SpinsCase do
  import ElixirRavelry.{UserCase, YarnCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Spins

  def create_spins(bolt_sips_conn) do
    user = create_user(bolt_sips_conn)
    yarn = create_yarn(bolt_sips_conn)
    Repo.Spins.create(bolt_sips_conn, %Spins{user_id: user.id, yarn_id: yarn.id})
  end
end