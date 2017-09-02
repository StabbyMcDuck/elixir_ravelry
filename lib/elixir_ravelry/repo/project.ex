defmodule ElixirRavelry.Repo.Project do
  @moduledoc false

  alias ElixirRavelryWeb.Project
  alias ElixirRavelry.Repo

  # Macros

  defmacro type, do: "Project"
  use ElixirRavelry.Repo.Node

  # Functions

  def create(conn, %Project{name: name}) do
    Repo.create_node(conn, %{type: type(), name: name})
  end

  def row_to_struct(
        %Bolt.Sips.Types.Node{
          id: id,
          labels: [type()],
          properties: %{
            "name" => name
          }
        }
      ) do
    %Project{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end