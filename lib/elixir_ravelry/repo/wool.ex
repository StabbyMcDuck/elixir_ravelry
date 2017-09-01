defmodule ElixirRavelry.Repo.Wool do
  @moduledoc false

  alias ElixirRavelryWeb.Wool
  alias ElixirRavelry.Repo

  # Macros

  defmacro type, do: "Wool"
  use ElixirRavelry.Repo.Node

  #Functions

  def create(conn, %Wool{name: name}) do
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
    %Wool{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end