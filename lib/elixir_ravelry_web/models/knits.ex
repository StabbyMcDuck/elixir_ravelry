defmodule ElixirRavelryWeb.Knits do
  use ElixirRavelryWeb, :model

  alias ElixirRavelryWeb.{User, Project}

  schema "KNITS" do
    belongs_to :user, User
    belongs_to :project, Project
  end

  defimpl Poison.Encoder do
    def encode(%{id: id, project_id: project_id, user_id: user_id}, options) do
      Poison.Encoder.Map.encode(%{id: id, project_id: project_id, user_id: user_id}, options)
    end
  end

end