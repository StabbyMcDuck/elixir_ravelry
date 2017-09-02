defmodule ElixirRavelry.OwnsCase do
  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Owns

  def create_owns(bolt_sips_conn, %{wool_id: wool_id, user_id: user_id}) do
    Repo.Owns.create(bolt_sips_conn, %Owns{started_at: Ecto.DateTime.utc(), user_id: user_id, wool_id: wool_id})
  end
end