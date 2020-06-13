defmodule GabblerData.Query.Subscription do
  @moduledoc """
  Coverage for queries involving a gabbler User
  """
  @behaviour GabblerData.Behaviour.QuerySubscription

  import Ecto.Query

  alias GabblerData.{Repo, Room, UserSubscription}


  @impl true
  def subscribe(%{id: id}, %Room{id: room_id}) do
    UserSubscription.changeset(%UserSubscription{}, %{user_id: id, room_id: room_id, type: "sub"})
    |> Repo.insert()
  end

  @impl true
  def unsubscribe(%{id: id}, %Room{id: room_id}) do
    UserSubscription
    |> Repo.get_by(user_id: id, room_id: room_id)
    |> UserSubscription.changeset()
    |> Repo.delete()
  end

  @impl true
  def subscribed?(%{id: id}, %Room{id: room_id}) do
    case Repo.one(from s in UserSubscription, where: s.user_id == ^id and s.room_id == ^room_id) do
      nil -> false
      _ -> true
    end
  end
  
  def subscribed?(_, %Room{}), do: false

  @impl true
  def list(%{id: id} = user, opts) do
    query = UserSubscription
    |> where([us], us.user_id == ^id)

    list(query, user, opts)
  end

  # PRIVATE FUNCTIONS
  ###################
  defp list(query, _user, []), do: query |> Repo.all()

  defp list(query, user, [{:join, :room}|opts]) do
    join(query, :left, [us], r in Room, on: us.room_id == r.id)
    |> select([us, r], {us, r})
    |> list(user, opts)
  end

  defp list(query, user, [{:limit, limit}|opts]) do
    list(limit(query, ^limit), user, opts)
  end
end