defmodule ElixirRavelry.Repo.Cards do
  @moduledoc false

  alias ElixirRavelryWeb.Cards
  alias ElixirRavelry.Repo

  # Macros

  @impl ElixirRavelry.Repo.Relationship
  defmacro type, do: "CARDS"
  use ElixirRavelry.Repo.Relationship

  #Functions

  @impl ElixirRavelry.Repo.Relationship
  def create(conn, %Cards{user_id: user_id, roving_id: roving_id}) do
    Repo.create_relationship(conn, %{type: type(), end_node_id: roving_id, start_node_id: user_id})
  end

  @impl ElixirRavelry.Repo.Relationship
  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": roving_id, id: id, start: user_id, type: type()}) do
    %Cards{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      roving_id: roving_id,
      user_id: user_id
    }
  end
end