defmodule ElixirRavelry.Repo do
  @moduledoc false

  def row_to_struct(relationship = %Bolt.Sips.Types.Relationship{type: type}) do
    repo_schema_module = type_to_repo_module(type)
    repo_schema_module.row_to_struct(relationship)
  end

  def row_to_struct(node = %Bolt.Sips.Types.Node{labels: [type | _]}) do
    repo_schema_module = type_to_repo_module(type)
    repo_schema_module.row_to_struct(node)
  end

  def type_to_repo_module("MATERIAL_FOR") do
    __MODULE__.MaterialFor
  end

  def type_to_repo_module(type) do
    Module.concat([__MODULE__, type])
  end

  def get(conn, type, id) do
    conn
    |> Bolt.Sips.query!(
         """
         MATCH (n:#{type})
         WHERE id(n) = toInteger({id})
         RETURN n
         """,
         %{id: id}
       )
    |> return_to_list()
    |> case do
         [] -> :error
         [node] -> {:ok, node}
       end
  end

  defp return_to_list(return) when is_list(return) do
    Enum.map(return, &return_to_struct/1)
  end

  defp return_to_struct(
        %{
          "n" => node
        }
      ) do
    row_to_struct(node)
  end


  #code from http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html
  epoch = {{1970, 1, 1}, {0, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def from_timestamp(timestamp) do
    timestamp
    |> Kernel.+(@epoch)
    |> :calendar.gregorian_seconds_to_datetime()
    |> Ecto.DateTime.from_erl()
  end

  def to_timestamp(datetime) do
    datetime
    |> Ecto.DateTime.to_erl()
    |> :calendar.datetime_to_gregorian_seconds()
    |> Kernel.-(@epoch)
  end
end