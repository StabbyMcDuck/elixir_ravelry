defmodule ElixirRavelry.Repo.DyedRoving do
  @moduledoc false

  alias ElixirRavelryWeb.DyedRoving
  alias ElixirRavelry.Repo

  # Macros

  defmacro type, do: "DyedRoving"
  use ElixirRavelry.Repo.Node

  # Functions

  def create(conn, %DyedRoving{name: name}) do
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
    %DyedRoving{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end