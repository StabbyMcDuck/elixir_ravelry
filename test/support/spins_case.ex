defmodule ElixirRavelry.SpinsCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Spins

  def create_spins(bolt_sips_conn, %{yarn_id: yarn_id, user_id: user_id}) do
    Repo.Spins.create(bolt_sips_conn, %Spins{user_id: user_id, yarn_id: yarn_id})
  end
end