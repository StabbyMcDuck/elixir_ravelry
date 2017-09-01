defmodule ElixirRavelry.Repo.Node do
  @moduledoc false


  @macrocallback type() :: String.t

  @callback row_to_struct(%Bolt.Sips.Types.Node{}) :: struct

  @callback create(conn :: %Bolt.Sips.Connection{}, struct) :: struct

  defmacro __using__([]) do
    quote do
      alias ElixirRavelry.Repo

      def get(conn, id) do
        Repo.get_node(conn, type(), id)
      end

      def graph(conn, id, direction) do
        Repo.graph(conn, type(), id, direction)
      end

      def list(conn) do
        Repo.list_node(conn, type())
      end
    end
  end
end