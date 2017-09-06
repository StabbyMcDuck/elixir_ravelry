defmodule ElixirRavelry.KnitsCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Knits

  def create_knits(bolt_sips_conn, %{project_id: project_id, user_id: user_id}) do
    {:ok, knits} = Repo.Knits.create(bolt_sips_conn, %Knits{user_id: user_id, project_id: project_id})
    knits
  end
end