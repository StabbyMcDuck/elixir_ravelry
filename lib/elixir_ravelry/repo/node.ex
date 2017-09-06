defmodule ElixirRavelry.Repo.Node do

  # Types
  @typedoc """
  id of a node
  """
  @type id :: pos_integer

  @typedoc """
  direction of a node

  * `"forward"` - only relationships and nodes of outgoing edges (including the node itself)
  * `"backwards"` - only relationships and nodes of incoming edges (including the node itself)
  * `"both"` - relationships and nodes of both incoming and outgoing edges
  """
  @type direction :: String.t

  # Callbacks

  @doc """
  Returns Cypher type of the node - CamelCased
  """
  @macrocallback type() :: String.t

  @doc """
  Converts a `Bolt.Sips.Types.Node` to an `Ecto.Schema` Struct
  """
  @callback row_to_struct(%Bolt.Sips.Types.Node{}) :: struct

  @doc """
  Creates a node using `Ecto.Schema` struct and returns `Ecto.Schema` struct with id filled in.  Uses `row_to_struct`
  """
  @callback create(conn :: %Bolt.Sips.Connection{}, struct) :: struct

  @doc """
  Get looks up a node by id and returns an `Ecto.Schema` struct created from that node. Uses `row_to_struct`
  """
  @callback get(conn :: %Bolt.Sips.Connection{}, id) :: struct

  @doc """
  Returns a flat list of all `Ecto.Schema` structs in a `direction`
  """
  @callback graph(conn :: %Bolt.Sips.Connection{}, id, direction, options :: map) :: [struct]

  @doc """
  Returns a list of `Ecto.Schema` structs for the nodes of a particular `type`
  """
  @callback list(conn :: %Bolt.Sips.Connection{}) :: [struct]

  defmacro __using__([]) do
    quote do
      @behaviour ElixirRavelry.Repo.Node
      alias ElixirRavelry.Repo

      @impl ElixirRavelry.Repo.Node
      def get(conn, id) do
        Repo.get_node(conn, type(), id)
      end

      @impl ElixirRavelry.Repo.Node
      def graph(conn, id, direction, options) do
        Repo.graph(conn, type(), id, direction, options)
      end

      @impl ElixirRavelry.Repo.Node
      def list(conn) do
        Repo.list_node(conn, type())
      end

      defoverridable [get: 2, graph: 4, list: 1]
    end
  end
end