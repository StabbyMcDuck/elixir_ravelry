defmodule ElixirRavelryWeb.Router do
  use ElixirRavelryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", ElixirRavelryWeb do
    pipe_through :api

    resources "/cards", CardsController, only: ~w(index show)a
    resources "/roving", RovingController, only: ~w(index show)a
    resources "/dyed_roving", DyedRovingController, only: ~w(index show)a do
      get "/graph", DyedRovingController, :graph
    end
    resources "/material-for", MaterialForController, only: ~w(index show)a
    resources "/owns", OwnsController, only: ~w(index show)a
    resources "/users", UserController, only: ~w(index show)a
    resources "/wool", WoolController, only: ~w(index show)a
  end
end
