defmodule ElixirRavelry.Repo.Knits do
  @moduledoc false

  alias ElixirRavelryWeb.Knits
  alias ElixirRavelry.Repo

  # Macros

  @impl ElixirRavelry.Repo.Relationship
  defmacro type, do: "KNITS"
  use ElixirRavelry.Repo.Relationship

  #Functions

  @impl ElixirRavelry.Repo.Relationship
  def create(conn, %Knits{user_id: user_id, project_id: project_id}) do
    Repo.create_relationship(conn, %{type: type(), end_node_id: project_id, start_node_id: user_id})
  end

  @impl ElixirRavelry.Repo.Relationship
  def row_to_struct(%Bolt.Sips.Types.Relationship{"end": project_id, id: id, start: user_id, type: type()}) do
    %Knits{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      project_id: project_id,
      user_id: user_id
    }
  end
end