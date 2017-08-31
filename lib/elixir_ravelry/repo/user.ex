defmodule ElixirRavelry.Repo.User do
  @moduledoc false

  alias ElixirRavelryWeb.User
  alias ElixirRavelry.Repo

  def create(conn, %User{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (n:User {name: {name}})
         RETURN n
         """,
         %{name: name}
       )
    |> return_to_users()
    |> hd()
  end

  def get(conn, id) do
    Repo.get_node(conn, "User", id)
  end

  def list(conn) do
    Repo.list_node(conn, "User")
  end

  def return_to_users(return) when is_list(return) do
    Enum.map(return, &return_to_user/1)
  end

  def return_to_user(
        %{
          "n" => node
        }
      ) do
    row_to_struct(node)
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