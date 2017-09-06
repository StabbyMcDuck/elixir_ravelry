defmodule ElixirRavelry.Repo.Spins do
  @moduledoc false

  alias ElixirRavelryWeb.Spins
  alias ElixirRavelry.Repo

  # Macros

  @impl ElixirRavelry.Repo.Relationship
  defmacro type, do: "SPINS"
  use ElixirRavelry.Repo.Relationship

  #Functions

  @impl ElixirRavelry.Repo.Relationship
  def create(conn, %Spins{user_id: user_id, yarn_id: yarn_id}) do
    Repo.create_relationship(conn, %{type: type(), end_node_id: yarn_id, start_node_id: user_id})
  end

  @impl ElixirRavelry.Repo.Relationship
  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": yarn_id, id: id, start: user_id, type: type()}) do
    %Spins{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      yarn_id: yarn_id,
      user_id: user_id
    }
  end
end