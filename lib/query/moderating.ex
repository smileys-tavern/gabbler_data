defmodule GabblerData.Query.Moderating do
  @moduledoc """
  Coverage for queries involving a gabbler User
  """
  @behaviour GabblerData.Behaviour.QueryModerating

  import Ecto.Query

  alias GabblerData.{Repo, User, Room, UserModerating}


  @impl true
  def moderate(%User{id: id}, %Room{id: room_id}) do
    UserModerating.changeset(%UserModerating{}, %{user_id: id, room_id: room_id, type: "mod"})
    |> Repo.insert()
  end

  @impl true
  def remove_moderate(%User{id: id}, %Room{id: room_id}) do
    UserModerating
    |> Repo.get_by(user_id: id, room_id: room_id)
    |> UserModerating.changeset()
    |> Repo.delete()
  end

  @impl true
  def moderating?(%User{id: id}, %Room{id: room_id}) do
    case Repo.one(from [um] in UserModerating, where: um.user_id == ^id and um.room_id == ^room_id) do
      nil -> false
      _ -> true
    end
  end

  @impl true
  def list(%User{id: id} = user, opts) do
    query = UserModerating
    |> where([um], um.user_id == ^id)

    list(query, user, opts)
  end

  # PRIVATE FUNCTIONS
  ###################
  defp list(query, _user, []), do: query |> Repo.all()

  defp list(query, user, [{:join, :room}|opts]) do
    join(query, :left, [um], r in Room, on: um.room_id == r.id)
    |> select([um, r], {um, r})
    |> list(user, opts)
  end

  defp list(query, user, [{:limit, limit}|opts]) do
    list(limit(query, ^limit), user, opts)
  end
end