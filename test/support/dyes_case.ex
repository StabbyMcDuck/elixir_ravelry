defmodule ElixirRavelry.DyesCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Dyes

  def create_dyes(bolt_sips_conn, %{dyed_roving_id: dyed_roving_id, user_id: user_id}) do
    {:ok, dyes} = Repo.Dyes.create(bolt_sips_conn, %Dyes{user_id: user_id, dyed_roving_id: dyed_roving_id})
    dyes
  end
end