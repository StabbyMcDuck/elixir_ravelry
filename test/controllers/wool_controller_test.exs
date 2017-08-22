defmodule ElixirRavelryWeb.WoolControllerTest do
  use ElixirRavelryWeb.ConnCase

  alias ElixirRavelry.Repo
  alias ElixirRavelryWeb.Wool

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

  test "GET /api/v1/wool without wool", %{conn: conn} do
    conn = get conn, "/api/v1/wool"
    assert json_response(conn, 200) == []
  end

  test "GET /api/v1/wool with wool", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    conn = get conn, "/api/v1/wool"
    assert json_response(conn, 200) == [%{"id" => wool.id, "name" => wool.name}]
  end

  test "GET /api/v1/wool/:id without wool", %{conn: conn} do
    conn = get conn, "/api/v1/wool/-1"
    assert json_response(conn, 404) == %{"error" => "Not Found"}
  end

  test "GET /api/v1/wool/:id with wool", %{bolt_sips_conn: bolt_sips_conn, conn: conn} do
    wool = create_wool(bolt_sips_conn)
    conn = get conn, "/api/v1/wool/#{wool.id}"
    assert json_response(conn, 200) == %{"id" => wool.id, "name" => wool.name}
  end

  # Private functions

  defp create_wool(bolt_sips_conn) do
    Repo.create_wool(bolt_sips_conn, %Wool{name: Faker.Name.name()})
  end
end
