defmodule ElixirRavelry.Repo.Dyeing do
  @moduledoc false

  alias ElixirRavelryWeb.Dyeing

  def create(conn, %Dyeing{name: name}) do
    conn
    |> Bolt.Sips.query!(
         """
         CREATE (d:Dyeing {name: {name}})
         RETURN d
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
         MATCH (d:Dyeing)
         WHERE id(d) = toInteger({id})
         RETURN d
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [dyeing] -> {:ok, dyeing}
       end
  end


  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (d:Dyeing)
         RETURN d
         """
       )
    |> return_to_list()
  end

  def return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_dyeing/1)
  end

  def return_to_dyeing(
        %{
          "d" => %Bolt.Sips.Types.Node{
            id: id,
            labels: ["Dyeing"],
            properties: %{
              "name" => name
            }
          }
        }
      ) do
    %Dyeing{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Dyeing"},
        state: :loaded
      },
      id: id,
      name: name
    }
  end
end