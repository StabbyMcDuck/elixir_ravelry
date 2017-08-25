defmodule ElixirRavelryWeb.DyeingControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.DyeingCase

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

  test "GET /api/v1/dyeing without dyeing", %{conn: conn} do
    conn = get conn, "/api/v1/dyeing"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/dyeing with dyeing", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    dyeing = create_dyeing(bolt_sips_conn)
    conn = get conn, "/api/v1/dyeing"
    assert json_response(conn, 200) == [%{"id" => dyeing.id, "name" => dyeing.name}]
  end

  test "GET /api/v1/dyeing/:id without dyeing", %{conn: conn} do
    conn = get conn, "/api/v1/dyeing/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/dyeing/:id with dyeing", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    dyeing = create_dyeing(bolt_sips_conn)
    conn = get conn, "/api/v1/dyeing/#{dyeing.id}"
    assert json_response(conn, 200) == %{"id" => dyeing.id, "name" => dyeing.name}
  end
end
