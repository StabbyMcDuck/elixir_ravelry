defmodule ElixirRavelryWeb.WoolControllerTest do
  use ElixirRavelryWeb.ConnCase
  use ElixirRavelry.Neo4jConnCase

  import ElixirRavelry.WoolCase

  # Test

  test "GET /api/v1/wool without wool", %{conn: conn} do
    conn = get conn, "/api/v1/wool"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/wool with wool", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    conn = get conn, "/api/v1/wool"
    assert json_response(conn, 200) == [%{"id" => wool.id, "name" => wool.name, "type" => "Wool"}]
  end

  test "GET /api/v1/wool/:id without wool", %{conn: conn} do
    conn = get conn, "/api/v1/wool/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/wool/:id with wool", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    conn = get conn, "/api/v1/wool/#{wool.id}"
    assert json_response(conn, 200) == %{"id" => wool.id, "name" => wool.name, "type" => "Wool"}
  end
end
