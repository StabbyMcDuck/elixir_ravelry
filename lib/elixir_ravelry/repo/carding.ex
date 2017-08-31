defmodule ElixirRavelry.Repo.Carding do
  @moduledoc false

  alias ElixirRavelryWeb.Carding

  def create(conn, %Carding{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (c:Carding {name: {name}})
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
         MATCH (c:Carding)
         WHERE id(c) = toInteger({id})
         RETURN c
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [carding] -> {:ok, carding}
       end
  end


  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (c:Carding)
         RETURN c
         """
       )
    |> return_to_list()
  end

  def return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_carding/1)
  end

  def return_to_carding(
        %{
          "c" => node
        }
      ) do
    row_to_struct(node)
  end

  def row_to_struct(
        %Bolt.Sips.Types.Node{
          id: id,
          labels: ["Carding"],
          properties: %{
            "name" => name
          }
        }
      ) do
    %Carding{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Carding"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end