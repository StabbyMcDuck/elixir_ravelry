defmodule ElixirRavelryWeb.OwnsControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.{OwnsCase}

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

  test "GET /api/v1/owns without owns", %{conn: conn} do
    conn = get conn, "/api/v1/owns"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/owns with owns", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    owns = create_owns(bolt_sips_conn)
    conn = get conn, "/api/v1/owns"
    assert json_response(conn, 200) == [%{"id" => owns.id, "started_at" => Ecto.DateTime.to_iso8601(owns.started_at), "user_id" => owns.user_id, "wool_id" => owns.wool_id}]
  end

  test "GET /api/v1/owns/:id without owns", %{conn: conn} do
    conn = get conn, "/api/v1/owns/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/owns/:id with owns", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    owns = create_owns(bolt_sips_conn)
    conn = get conn, "/api/v1/owns/#{owns.id}"
    assert json_response(conn, 200) == %{"id" => owns.id, "started_at" => Ecto.DateTime.to_iso8601(owns.started_at), "user_id" => owns.user_id, "wool_id" => owns.wool_id}
  end

end
