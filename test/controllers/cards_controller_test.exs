defmodule ElixirRavelryWeb.CardsControllerTest do
  use ElixirRavelryWeb.ConnCase
  use ElixirRavelry.Neo4jConnCase
  
  import ElixirRavelry.{CardsCase}

  # Test

  test "GET /api/v1/cards without cards", %{conn: conn} do
    conn = get conn, "/api/v1/cards"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/cards with cards", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    cards = create_cards(bolt_sips_conn)
    conn = get conn, "/api/v1/cards"
    assert json_response(conn, 200) == [%{"id" => cards.id, "user_id" => cards.user_id, "roving_id" => cards.roving_id}]
  end

  test "GET /api/v1/cards/:id without cards", %{conn: conn} do
    conn = get conn, "/api/v1/cards/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/cards/:id with cards", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    cards = create_cards(bolt_sips_conn)
    conn = get conn, "/api/v1/cards/#{cards.id}"
    assert json_response(conn, 200) == %{"id" => cards.id, "user_id" => cards.user_id, "roving_id" => cards.roving_id}
  end
end
