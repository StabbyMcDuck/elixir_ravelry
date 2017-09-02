defmodule ElixirRavelryWeb.SpinsControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.{SpinsCase, UserCase, YarnCase}

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

  test "GET /api/v1/spins without spins", %{conn: conn} do
    conn = get conn, "/api/v1/spins"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/spins with spins", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    user = create_user(bolt_sips_conn)
    yarn = create_yarn(bolt_sips_conn)
    spins = create_spins(bolt_sips_conn, %{user_id: user.id, yarn_id: yarn.id})
    conn = get conn, "/api/v1/spins"
    assert json_response(conn, 200) == [%{"id" => spins.id, "user_id" => spins.user_id, "yarn_id" => spins.yarn_id, "type" => "Spins"}]
  end

  test "GET /api/v1/spins/:id without spins", %{conn: conn} do
    conn = get conn, "/api/v1/spins/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/spins/:id with spins", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    user = create_user(bolt_sips_conn)
    yarn = create_yarn(bolt_sips_conn)
    spins = create_spins(bolt_sips_conn, %{user_id: user.id, yarn_id: yarn.id})
    conn = get conn, "/api/v1/spins/#{spins.id}"
    assert json_response(conn, 200) == %{"id" => spins.id, "user_id" => spins.user_id, "yarn_id" => spins.yarn_id, "type" => "Spins"}
  end

end
