defmodule ElixirRavelry.Neo4jConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a neo4j connection.
  """
  
  use ExUnit.CaseTemplate

  # Callbacks
  setup %{conn: conn} do
    bolt_sips_conn = 
      Bolt.Sips.conn()
      |> Bolt.Sips.begin()

    on_exit fn ->
      Bolt.Sips.rollback(bolt_sips_conn)
    end

    conn = Plug.Conn.put_private(conn, :bolt_sips_conn, bolt_sips_conn)

    %{bolt_sips_conn: bolt_sips_conn, conn: conn}
  end
    
end