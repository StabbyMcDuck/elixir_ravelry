defmodule ElixirRavelry.Repo.Roving do
  @moduledoc false

  alias ElixirRavelryWeb.Roving

  def create(conn, %Roving{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (c:Roving {name: {name}})
         RETURN c
         """,
         %{name: name}
       )
    |> return_to_list()
    |> hd()
  end

  def get(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (c:Roving)
         WHERE id(c) = toInteger({id})
         RETURN c
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [roving] -> {:ok, roving}
       end
  end


  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (c:Roving)
         RETURN c
         """
       )
    |> return_to_list()
  end

  def return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_roving/1)
  end

  def return_to_roving(
        %{
          "c" => node
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