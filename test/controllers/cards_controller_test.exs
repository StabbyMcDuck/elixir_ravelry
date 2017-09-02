defmodule ElixirRavelryWeb.CardsControllerTest do
  use ElixirRavelryWeb.ConnCase

  import ElixirRavelry.{CardsCase, RovingCase, UserCase}

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

  test "GET /api/v1/cards without cards", %{conn: conn} do
    conn = get conn, "/api/v1/cards"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/cards with cards", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    roving = create_roving(bolt_sips_conn)
    user = create_user(bolt_sips_conn)
    cards = create_cards(bolt_sips_conn, %{user_id: user.id, roving_id: roving.id})
    conn = get conn, "/api/v1/cards"
    assert json_response(conn, 200) == [%{"id" => cards.id, "user_id" => cards.user_id, "roving_id" => cards.roving_id, "type" => "Cards"}]
  end

  test "GET /api/v1/cards/:id without cards", %{conn: conn} do
    conn = get conn, "/api/v1/cards/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/cards/:id with cards", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    roving = create_roving(bolt_sips_conn)
    user = create_user(bolt_sips_conn)
    cards = create_cards(bolt_sips_conn, %{user_id: user.id, roving_id: roving.id})
    conn = get conn, "/api/v1/cards/#{cards.id}"
    assert json_response(conn, 200) == %{"id" => cards.id, "user_id" => cards.user_id, "roving_id" => cards.roving_id, "type" => "Cards"}
  end
end
