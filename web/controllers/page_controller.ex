defmodule ElixirRavelry.PageController do
  use ElixirRavelry.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
