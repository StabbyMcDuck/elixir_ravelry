defmodule ElixirRavelry.Repo.Roving do
  @moduledoc false

  alias ElixirRavelryWeb.Roving
  alias ElixirRavelry.Repo

  # Macros

  defmacro type, do: "Roving"
  use ElixirRavelry.Repo.Node

  # Functions

  def create(conn, %Roving{name: name}) do
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
    %Roving{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end