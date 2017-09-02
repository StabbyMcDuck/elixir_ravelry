defmodule ElixirRavelry.DyesCase do
  import ElixirRavelry.{UserCase, DyedRovingCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Dyes

  def create_dyes(bolt_sips_conn) do
    user = create_user(bolt_sips_conn)
    dyed_roving = create_dyed_roving(bolt_sips_conn)
    Repo.Dyes.create(bolt_sips_conn, %Dyes{user_id: user.id, dyed_roving_id: dyed_roving.id})
  end
end