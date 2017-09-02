defmodule ElixirRavelry.Repo.Yarn do
  @moduledoc false

  alias ElixirRavelryWeb.Yarn
  alias ElixirRavelry.Repo

  # Macros

  defmacro type, do: "Yarn"
  use ElixirRavelry.Repo.Node

  # Functions

  def create(conn, %Yarn{name: name}) do
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
    %Yarn{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end