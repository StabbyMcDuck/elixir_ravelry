defmodule ElixirRavelry.OwnsCase do
  import ElixirRavelry.{UserCase, WoolCase}

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Owns

  def create_owns(bolt_sips_conn) do
    user = create_user(bolt_sips_conn)
    wool = create_wool(bolt_sips_conn)
    Repo.Owns.create(bolt_sips_conn, %Owns{started_at: Ecto.DateTime.utc(), user_id: user.id, wool_id: wool.id})
  end
end