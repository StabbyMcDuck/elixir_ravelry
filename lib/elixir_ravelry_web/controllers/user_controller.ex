# Rename PageController to UserController
defmodule ElixirRavelryWeb.UserController do
  use ElixirRavelryWeb, :controller

  alias ElixirRavelry.Repo

  def index(conn, _params) do
    users = conn
            |> bolt_sips_conn()
            |> Repo.User.list()
    json conn, users
  end

  def show(conn, %{"id"=>id}) do
    conn
      |> bolt_sips_conn()
      |> Repo.User.get(id)
      |> case do
           {:ok, user} -> json conn, user
                          :error -> not_found(conn)
         end
  end
end

