defmodule ElixirRavelry.Repo.User do
  @moduledoc false

  alias ElixirRavelryWeb.User
  alias ElixirRavelry.Repo

  # Macros

  defmacro type, do: "User"
  use ElixirRavelry.Repo.Node

  # Function

  def create(conn, %User{name: name}) do
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
    %User{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, type()},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end