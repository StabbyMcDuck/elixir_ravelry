defmodule ElixirRavelry.Repo.User do
  @moduledoc false

  alias ElixirRavelryWeb.{User, Wool, Owns}

  def create(conn, %User{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (u:User {name: {name}})
         RETURN u
         """,
         %{name: name}
       )
    |> return_to_users()
    |> hd()
  end

  def get(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User)
         WHERE id(u) = toInteger({id})
         RETURN u
         """,
         %{id: id}
       )
    |> return_to_users()
    |> case do
         [] -> :error
         [user] -> {:ok, user}
       end
  end


  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (u:User)
         RETURN u
         """
       )
    |> return_to_users()
  end

  def return_to_users(return) when is_list(return) do
    Enum.map(return, &return_to_user/1)
  end

  def return_to_user(
        %{
          "u" => %Bolt.Sips.Types.Node{
            id: id,
            labels: ["User"],
            properties: %{
              "name" => name
            }
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