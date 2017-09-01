defmodule ElixirRavelry.Repo.Wool do
  @moduledoc false

  alias ElixirRavelryWeb.Wool
  alias ElixirRavelry.Repo

  def create(conn, %Wool{name: name}) do
    Repo.create_node(conn, %{type: "Wool", name: name})
  end

  def get(conn, id) do
    Repo.get_node(conn, "Wool", id)
  end

  def list(conn) do
    Repo.list_node(conn, "Wool")
  end

  def row_to_struct(
        %Bolt.Sips.Types.Node{
          id: id,
          labels: ["Wool"],
          properties: %{
            "name" => name
          }
        }
      ) do
    %Wool{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Wool"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end