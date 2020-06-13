defmodule GabblerData.Query.Room do
  @moduledoc """
  Query the room using behaviour specification to ensure implementation has full
  coverage required.
  """
  @behaviour GabblerData.Behaviour.QueryRoom

  alias GabblerData.Room

  alias GabblerData.Repo


  @impl true
  def get(id), do: Room |> Repo.get_by(id: id)
  @impl true
  def get_by_name(name), do: Room |> Repo.get_by(name: name)

  @impl true
  def list(_), do: []

  @impl true
  def increment_reputation(_, _), do: {:ok, %Room{}}

  @impl true
  def create(changeset), do: Repo.insert(changeset)

  @impl true
  def update(changeset), do: Repo.update(changeset)
end