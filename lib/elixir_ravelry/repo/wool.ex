defmodule ElixirRavelry.Repo.Wool do
  @moduledoc false

  alias ElixirRavelryWeb.{User, Wool, Owns}

  def create(conn, %Wool{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (w:Wool {name: {name}})
         RETURN w
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
         MATCH (w:Wool)
         WHERE id(w) = toInteger({id})
         RETURN w
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [wool] -> {:ok, wool}
       end
  end


  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (w:Wool)
         RETURN w
         """
       )
    |> return_to_list()
  end

  def return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_wool/1)
  end

  def return_to_wool(
        %{
          "w" => %Bolt.Sips.Types.Node{
            id: id,
            labels: ["Wool"],
            properties: %{
              "name" => name
            }
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