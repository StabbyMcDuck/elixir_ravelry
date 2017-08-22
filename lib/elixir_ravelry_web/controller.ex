defmodule ElixirRavelryWeb.Controller do
  import Plug.Conn
  import Phoenix.Controller

  def bolt_sips_conn(conn) do
    Map.get_lazy(conn.private, :bolt_sips_conn, &Bolt.Sips.conn/0)
  end

  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{"error" => "Not Found"})
  end
end