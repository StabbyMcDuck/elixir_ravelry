# Rename PageController to UserController
defmodule ElixirRavelryWeb.UserController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    users = conn
            |> bolt_sips_conn()
            |> Repo.list_users()
    json conn, users
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.get_user(id)
      |> case do
           {:ok, user} -> json conn, user
                          :error -> not_found(conn)
         end
  end


  ## private functions

  defp bolt_sips_conn(conn) do
    Map.get_lazy(conn.private, :bolt_sips_conn, &Bolt.Sips.conn/0)
  end

  defp not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{"error" => "Not Found"})
  end
end

