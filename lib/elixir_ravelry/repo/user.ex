defmodule ElixirRavelry.Repo.User do
  @moduledoc false

  alias ElixirRavelryWeb.User
  alias ElixirRavelry.Repo

  def create(conn, %User{name: name}) do
    Repo.create_node(conn, %{type: "User", name: name})
  end

  def get(conn, id) do
    Repo.get_node(conn, "User", id)
  end

  def list(conn) do
    Repo.list_node(conn, "User")
  end

  def row_to_struct(
        %Bolt.Sips.Types.Node{
          id: id,
          labels: ["User"],
          properties: %{
            "name" => name
          }
        }

      ) do
    %User{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "User"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end