defmodule ElixirRavelry.Repo.Wool do
  @moduledoc false

  alias ElixirRavelryWeb.Wool
  alias ElixirRavelry.Repo

  def create(conn, %Wool{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (n:Wool {name: {name}})
         RETURN n
         """,
         %{name: name}
       )
    |> return_to_list()
    |> hd()
  end

  def get(conn, id) do
    Repo.get(conn, "Wool", id)
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (n:Wool)
         RETURN n
         """
       )
    |> return_to_list()
  end

  def return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_wool/1)
  end

  def return_to_wool(
        %{
          "n" => node
        }
      ) do
    row_to_struct(node)
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