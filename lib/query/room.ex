defmodule GabblerData.Query.Room do
  @moduledoc """
  Query the room using behaviour specification to ensure implementation has full
  coverage required.
  """
  @behaviour GabblerData.Behaviour.QueryRoom

  import Ecto.Query

  alias GabblerData.Room
  alias GabblerData.RoomBan

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

  # Banning functionality

  @impl true
  def ban_for_life(id, user_id) do
    RoomBan.changeset(%RoomBan{:room_id => id, :user_id => user_id})
    |> Repo.insert()
  end

  @impl true
  def unban(id, user_id) do
    RoomBan.changeset(%RoomBan{:room_id => id, :user_id => user_id})
    |> Repo.delete()
  end

  @impl true
  def banned?(id, user_id) do
    result = RoomBan
    |> where(room_id: ^id, user_id: ^user_id)
    |> Repo.one()

    case result do
      nil -> false
      _ -> true
    end
  end
end