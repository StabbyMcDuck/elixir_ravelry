defmodule ElixirRavelryWeb.GraphChannel do
  use Phoenix.Channel

  def join("graph:" <> _node_id, _params, socket) do
    {:ok, socket}
  end

end