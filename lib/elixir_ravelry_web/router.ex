defmodule ElixirRavelryWeb.Router do
  use ElixirRavelryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", ElixirRavelryWeb do
    pipe_through :api

    get "/users", UserController, :index
  end
end
