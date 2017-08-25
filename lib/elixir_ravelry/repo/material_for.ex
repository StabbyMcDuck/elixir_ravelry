defmodule ElixirRavelry.Repo.Material_for do
  @moduledoc false

  alias ElixirRavelryWeb.{Material_for}

  def create(conn, %Material_for{wool_id: wool_id, carding_id: carding_id}) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (w:Wool) WHERE id(w) = {wool_id}
         MATCH (l:Carding) WHERE id(l) = {carding_id}
         CREATE (w)-[m:MATERIAL_FOR]->(l)
         RETURN m
         """,
         %{wool_id: wool_id, carding_id: carding_id}
       )
    |> return_to_material_for_list()
    |> hd()
  end

  def get(conn, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (:Wool)-[m:MATERIAL_FOR]->(:Carding)
         WHERE id(m) = toInteger({id})
         RETURN m
         """,
         %{id: id}
       )
    |> return_to_material_for_list()
    |> case do
         [] -> :error
         [material_for] -> {:ok, material_for}
       end
  end

  def list(conn) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (:Wool)-[m:MATERIAL_FOR]->(:Carding)
         RETURN m
         """
       )
    |> return_to_material_for_list()
  end

  def return_to_material_for_list(return) when is_list(return) do
    Enum.map(return, &return_to_material_for/1)
  end

  def return_to_material_for(%{"m" => %Bolt.Sips.Types.Relationship{"end": carding_id, id: id, start: wool_id, type: "MATERIAL_FOR"}}) do
    %Material_for{
      __meta__: %Ecto.Schema.Metadata{
        source: {nil, "Material_for"},
        state: :loaded
      },
      id: id,
      carding_id: carding_id,
      wool_id: wool_id
    }
  end
end