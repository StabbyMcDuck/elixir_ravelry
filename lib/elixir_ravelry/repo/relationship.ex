defmodule ElixirRavelry.Repo.Relationship do
  @moduledoc false


  @macrocallback type() :: String.t

  @callback row_to_struct(%Bolt.Sips.Types.Relationship{}) :: struct

  @callback create(conn :: %Bolt.Sips.Connection{}, struct) :: struct

  defmacro __using__([]) do
    quote do
      alias ElixirRavelry.Repo

      def get(conn, id) do
        Repo.get_relationship(conn, type(), id)
      end

      def list(conn) do
        Repo.list_relationship(conn, type())
      end
    end
  end
end