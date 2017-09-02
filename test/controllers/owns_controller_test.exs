defmodule ElixirRavelryWeb.OwnsControllerTest do
  use ElixirRavelryWeb.ConnCase
  use ElixirRavelry.Neo4jConnCase

  import ElixirRavelry.{OwnsCase, UserCase, WoolCase}

  # Test

  test "GET /api/v1/owns without owns", %{conn: conn} do
    conn = get conn, "/api/v1/owns"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/owns with owns", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    user = create_user(bolt_sips_conn)
    owns = create_owns(bolt_sips_conn, %{user_id: user.id, wool_id: wool.id})
    conn = get conn, "/api/v1/owns"
    assert json_response(conn, 200) == [%{"id" => owns.id, "started_at" => Ecto.DateTime.to_iso8601(owns.started_at), "user_id" => owns.user_id, "wool_id" => owns.wool_id, "type" => "Owns"}]
  end

  test "GET /api/v1/owns/:id without owns", %{conn: conn} do
    conn = get conn, "/api/v1/owns/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/owns/:id with owns", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    user = create_user(bolt_sips_conn)
    owns = create_owns(bolt_sips_conn, %{user_id: user.id, wool_id: wool.id})
    conn = get conn, "/api/v1/owns/#{owns.id}"
    assert json_response(conn, 200) == %{"id" => owns.id, "started_at" => Ecto.DateTime.to_iso8601(owns.started_at), "user_id" => owns.user_id, "wool_id" => owns.wool_id, "type" => "Owns"}
  end

end
