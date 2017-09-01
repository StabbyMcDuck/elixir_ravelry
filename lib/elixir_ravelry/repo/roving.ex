defmodule ElixirRavelry.Repo.Roving do
  @moduledoc false

  alias ElixirRavelryWeb.Roving
  alias ElixirRavelry.Repo

  def create(conn, %Roving{name: name}) do
    Repo.create_node(conn, %{type: "Roving", name: name})
  end

  def get(conn, id) do
    Repo.get_node(conn, "Roving", id)
  end

  def list(conn) do
    Repo.list_node(conn, "Roving")
  end

  def return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_roving/1)
  end

  def return_to_roving(
        %{
          "n" => node
        }
      ) do
    row_to_struct(node)
  end

  def row_to_struct(
        %Bolt.Sips.Types.Node{
          id: id,
          labels: ["Roving"],
          properties: %{
            "name" => name
          }
        }
      ) do
    %Roving{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Roving"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end