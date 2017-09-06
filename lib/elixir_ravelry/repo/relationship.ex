defmodule ElixirRavelry.Repo.Relationship do
  @moduledoc false

  @typedoc """
  id of a relationship
  """
  @type id :: pos_integer

  @macrocallback type() :: String.t

  @callback get(conn :: %Bolt.Sips.Connection{}, id) :: struct

  @callback create(conn :: %Bolt.Sips.Connection{}, struct) :: {:ok, struct} | :error

  @callback list(conn :: %Bolt.Sips.Connection{}) :: [struct]

  @callback row_to_struct(%Bolt.Sips.Types.Relationship{}) :: struct

  defmacro __using__([]) do
    quote do
      alias ElixirRavelry.Repo
      @behaviour ElixirRavelry.Repo.Relationship

      @impl ElixirRavelry.Repo.Relationship
      def get(conn, id) do
        Repo.get_relationship(conn, type(), id)
      end

      @impl ElixirRavelry.Repo.Relationship
      def list(conn) do
        Repo.list_relationship(conn, type())
      end
    end
  end
end