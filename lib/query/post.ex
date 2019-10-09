defmodule GabblerData.Query.Post do
  @moduledoc """
  Query the post using behaviour specification to ensure implementation has full
  coverage required.
  """
  @behaviour GabblerData.Behaviour.QueryPost

  import Ecto.Query

  alias GabblerData.{Post, Room, PostMeta, Comment}

  alias GabblerData.Repo

  @thread_query_max 20
  @thread_query_focus_max 20


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
  def create_reply(changeset), do: Repo.insert(changeset)

  @impl true
  def update(changeset), do: Repo.update(changeset)

  @impl true
  def update_meta(changeset), do: Repo.update(changeset)

  @impl true
  def thread(%Post{id: id}, :new), do: thread_query(
    Integer.to_string(id), "(p.id * -1)::bigint", Integer.to_string(@thread_query_max))
  def thread(%Post{id: id}, :focus), do: thread_query(
    Integer.to_string(id), "(p.score_private * -1)::bigint", Integer.to_string(@thread_query_focus_max))
  def thread(%Post{id: id}, _), do: thread_query(
    Integer.to_string(id), "(p.score_private * -1)::bigint", Integer.to_string(@thread_query_max))

  defp thread_query(post_id_string, sort_modifier, limit_string) do
    qry = "
      WITH RECURSIVE posts_r(id, user_id_post, room_id, parent_id, parent_type, body, age, hash, score_public, 
        score_private, inserted_at, depth, path) AS (
            SELECT p.id, p.user_id_post, p.room_id, p.parent_id, p.parent_type, body, age, hash, score_public, 
              score_private, inserted_at, 1, ARRAY[#{sort_modifier}, p.id]
            FROM posts p
            WHERE p.parent_id = #{post_id_string} AND p.parent_type != 'room'
          UNION ALL
            SELECT p.id, p.user_id_post, p.room_id, p.parent_id, p.parent_type, p.body, p.age, p.hash, p.score_public, 
              p.score_private, p.inserted_at, pr.depth + 1, path || #{sort_modifier} || p.id
            FROM posts p, posts_r pr
          WHERE p.parent_id = pr.id AND p.parent_type != 'room'
      )
      SELECT psr.id, psr.user_id_post, psr.room_id, psr.parent_id, psr.parent_type, psr.body, psr.age, psr.hash, 
        psr.score_public, psr.score_private, psr.inserted_at, psr.depth, psr.path, u.name
      FROM posts_r psr LEFT JOIN users u ON psr.user_id_post = u.id 
      ORDER BY path LIMIT #{limit_string}
    "

    res = Ecto.Adapters.SQL.query!(Repo, qry, [])

    cols = Enum.map res.columns, &(String.to_atom(&1))

    Enum.map(res.rows, fn row ->
      # Comment is a Post like struct but gives us some flexibility to differentiate
      struct(Comment, Enum.zip(cols, row))
    end)
  end

  defp list(query, []), do: query |> Repo.all()

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

  defp list(query, [{:order_by, :inserted_at}|opts]) do
    list(order_by(query, [p], desc: p.inserted_at), opts)
  end

  defp list(query, [{:order_by, :score_public}|opts]) do
    list(order_by(query, [p], desc: p.score_public), opts)
  end

  defp list(query, [{:order_by, :score_private}|opts]) do
    list(order_by(query, [p], desc: p.score_private), opts)
  end

  defp list(query, [{:limit, limit}|opts]) do
    list(limit(query, ^limit), opts)
  end
end