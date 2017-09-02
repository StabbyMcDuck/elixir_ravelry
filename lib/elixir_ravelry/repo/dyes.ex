defmodule ElixirRavelry.Repo.Dyes do
  @moduledoc false

  alias ElixirRavelryWeb.Dyes
  alias ElixirRavelry.Repo

  # Macros

  defmacro type, do: "DYES"
  use ElixirRavelry.Repo.Relationship

  #Functions

  def create(conn, %Dyes{user_id: user_id, dyed_roving_id: dyed_roving_id}) do
    Repo.create_relationship(conn, %{type: type(), end_node_id: dyed_roving_id, start_node_id: user_id})
  end

  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": dyed_roving_id, id: id, start: user_id, type: type()}) do
    %Dyes{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      dyed_roving_id: dyed_roving_id,
      user_id: user_id
    }
  end
end