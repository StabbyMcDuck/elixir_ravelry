defmodule ElixirRavelryWeb.UserControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.UserCase

  # Callbacks

  setup %{conn: conn} do
    bolt_sips_conn = Bolt.Sips.conn()
                     |> Bolt.Sips.begin()

    on_exit fn ->
      Bolt.Sips.rollback(bolt_sips_conn)
    end

    conn = Plug.Conn.put_private(conn, :bolt_sips_conn, bolt_sips_conn)

    %{bolt_sips_conn: bolt_sips_conn, conn: conn}
  end

  # Test

  test "GET /api/v1/users without users", %{conn: conn} do
    conn = get conn, "/api/v1/users"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/users with users", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    user = create_user(bolt_sips_conn)
    conn = get conn, "/api/v1/users"
    assert json_response(conn, 200) == [%{"id" => user.id, "name" => user.name, "type" => "User"}]
  end

  test "GET /api/v1/users/:id without users", %{conn: conn} do
    conn = get conn, "/api/v1/users/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/users/:id with users", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    user = create_user(bolt_sips_conn)
    conn = get conn, "/api/v1/users/#{user.id}"
    assert json_response(conn, 200) == %{"id" => user.id, "name" => user.name, "type" => "User"}
  end

end
