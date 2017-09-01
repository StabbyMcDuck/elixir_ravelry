defmodule ElixirRavelry.Repo.DyedRoving do
  @moduledoc false

  alias ElixirRavelryWeb.DyedRoving
  alias ElixirRavelry.Repo

  def create(conn, %DyedRoving{name: name}) do
    Repo.create_node(conn, %{type: "DyedRoving", name: name})
  end

  def get(conn, id) do
    Repo.get_node(conn, "DyedRoving", id)
  end

  def graph(conn, id, direction) do
    Repo.graph(conn, "DyedRoving", id, direction)
  end

  def list(conn) do
    Repo.list_node(conn, "DyedRoving")
  end

  def row_to_struct(
        %Bolt.Sips.Types.Node{
          id: id,
          labels: ["DyedRoving"],
          properties: %{
            "name" => name
          }
        }
      ) do
    %DyedRoving{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "DyedRoving"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end