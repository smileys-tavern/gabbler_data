defmodule GabblerData.Query.Moderating do
  @moduledoc """
  Coverage for queries involving a gabbler User
  """
  @behaviour GabblerData.Behaviour.QueryModerating

  import Ecto.Query

  alias GabblerData.{Repo, Room, UserModerating}


  @impl true
  def moderate(%{id: id}, %Room{id: room_id}) do
    UserModerating.changeset(%UserModerating{}, %{user_id: id, room_id: room_id, type: "mod"})
    |> Repo.insert()
  end

  @impl true
  def remove_moderate(%{id: id}, %Room{id: room_id}) do
    UserModerating
    |> Repo.get_by(user_id: id, room_id: room_id)
    |> UserModerating.changeset()
    |> Repo.delete()
  end

  @impl true
  def moderating?(%{id: id}, %Room{user_id: creator_id}) when id == creator_id, do: true

  def moderating?(%{id: id}, %Room{id: room_id}) do
    case Repo.one(from [um] in UserModerating, where: um.user_id == ^id and um.room_id == ^room_id) do
      nil -> false
      _ -> true
    end
  end

  @impl true
  def list(%{id: id}, opts) do
    query = UserModerating
    |> where([um], um.user_id == ^id)

    list_opts(query, opts)
  end

  @impl true
  def list(%Room{id: id}, opts) do
    query = UserModerating
    |> where([um], um.room_id == ^id)

    list_opts(query, opts)
  end

  # PRIVATE FUNCTIONS
  ###################
  defp list_opts(query, []), do: query |> Repo.all()

  defp list_opts(query, [{:join, :room}|opts]) do
    join(query, :left, [um], r in Room, on: um.room_id == r.id)
    |> select([um, r], {um, r})
    |> list_opts(opts)
  end

  defp list_opts(query, [{:join, :user}|opts]) do
    user = Application.get_env(:gabbler_data, :user)

    join(query, :left, [um], u in ^user, on: um.user_id == u.id)
    |> select([um, u], {um, u})
    |> list_opts(opts)
  end

  defp list_opts(query, [{:limit, limit}|opts]) do
    list_opts(limit(query, ^limit), opts)
  end
end