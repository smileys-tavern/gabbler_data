defmodule GabblerData.Query.Post do
  @moduledoc """
  Query the post using behaviour specification to ensure implementation has full
  coverage required.
  """
  @behaviour GabblerData.Default.PostBehaviour

  import Ecto.Query

  alias GabblerData.{Post, Room, PostMeta}

  alias GabblerData.Repo


  @impl true
  def get(hash) when is_binary(hash), do: Post |> Repo.get_by(hash: hash)
  def get(id) when is_integer(id), do: Post |> Repo.get_by(id: id)

  @impl true
  def list(opts), do: list(Post, opts)

  @impl true
  def map_meta(posts) do
    ids = Enum.reduce(posts, [], fn %{id: id}, acc -> [id|acc] end)

    post_metas = PostMeta 
    |> where([p], p.post_id in ^ids)
    |> Repo.all()

    Enum.reduce(post_metas, %{}, fn %{post_id: post_id} = post_meta, acc -> Map.put(acc, post_id, post_meta) end)
  end

  @impl true
  def create(changeset, changeset_meta) do
    Repo.transaction fn ->
      case Repo.insert(changeset) do
        {:ok, %{id: post_id} = post} ->
          case Repo.insert(PostMeta.changeset(changeset_meta, %{:post_id => post_id})) do
            {:ok, post_meta} -> 
              {post, post_meta}
            {:error, error} -> 
              Repo.rollback({:post_meta, error})
          end
        {:error, error} ->
          Repo.rollback({:post, error})
      end
    end
  end

  @impl true
  def update(changeset), do: Repo.update(changeset)

  @impl true
  def update_meta(changeset), do: Repo.update(changeset)

  defp list(query, []), do: query |> IO.inspect() |> Repo.all()

  defp list(query, [{:by_user, id}|opts]) do
    list(where(query, user_id_post: ^id), opts)
  end

  defp list(query, [{:by_room, id}|opts]) do
    query = query
    |> join(:left, [p], r in Room, on: p.room_id == r.id)
    |> where(parent_type: "room")
    |> where(parent_id: ^id)

    list(query, opts)
  end

  defp list(query, [{:order_by, :updated}|opts]) do
    list(order_by(query, [p], desc: p.updated_at), opts)
  end

  defp list(query, [{:order_by, :score_public}|opts]) do
    list(order_by(query, [p], desc: p.score_public), opts)
  end

  defp list(query, [{:limit, limit}|opts]) do
    list(limit(query, ^limit), opts)
  end
end