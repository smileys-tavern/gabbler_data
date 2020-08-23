defmodule GabblerData.Query.Post do
  @moduledoc """
  Query the post using behaviour specification to ensure implementation has full
  coverage required.
  """
  @behaviour GabblerData.Behaviour.QueryPost

  import Ecto.Query

  alias GabblerData.{Post, Room, PostMeta, Comment, StoryImage}
  alias GabblerData.Query.Room, as: QueryRoom
  alias GabblerData.Query.User, as: QueryUser

  alias GabblerData.Repo

  @thread_query_max 20


  @impl true
  def get(id), do: Post |> Repo.get_by(id: id)
  @impl true
  def get_by_hash(hash), do: Post |> Repo.get_by(hash: hash)
  @impl true
  def get_meta(%Post{id: id}), do: PostMeta |> Repo.get_by(post_id: id)

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
  def map_rooms(posts) do
    Enum.reduce(posts, %{}, fn %{id: post_id, room_id: room_id}, acc -> 
      Map.put(acc, post_id, QueryRoom.get(room_id))
    end)
  end

  @impl true
  def map_users(posts) do
    Enum.reduce(posts, %{}, fn %{id: post_id, user_id: user_id}, acc -> 
      Map.put(acc, post_id, QueryUser.get(user_id))
    end)
  end

  @impl true
  def get_story_images(%PostMeta{image: story_hash}) when is_binary(story_hash) do
    StoryImage
    |> where(story_hash: ^story_hash)
    |> order_by([s], asc: s.story_order)
    |> Repo.all()
  end

  def get_story_images(_), do: []

  @impl true
  def update_story_image_order(public_id, i) do
    StoryImage
    |> where(public_id: ^public_id)
    |> Repo.update_all(set: [story_order: i])
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
  def increment_score(%{id: id}, amt, nil) do
    Post
    |> where(id: ^id)
    |> Repo.update_all(inc: [score_public: amt, score_private: amt, score_alltime: abs(amt)])
  end

  def increment_score(%{id: id}, amt, amt_priv) do
    Post 
    |> where(id: ^id)
    |> Repo.update_all(inc: [score_public: amt, score_private: amt_priv, score_alltime: amt_priv])
  end

  @impl true
  def comment_count(%Post{id: id}) do
    Post
    |> where(parent_id: ^id)
    |> Repo.aggregate(:count, :id)
  end

  @impl true
  def page_count(%Post{} = post), do:
    (comment_count(post) / @thread_query_max)
    |> ceil()
  
  @impl true
  def thread(post, mode, page \\ 1, level \\ 1, opts \\ [])

  def thread(%{id: id}, mode, page, level, opts) do
    thread_query(
      Comment |> where(parent_id: ^id), 
      [
        {:mode, mode}, 
        {:limit, @thread_query_max},
        {:offset, (page - 1) * @thread_query_max} | opts
      ],
      level
    ) 
    |> Repo.all()
  end

  @impl true
  def create_story_image(changeset), do: Repo.insert(changeset, returning: [:public_id])

  @impl true
  def delete_story_image(public_id) do
    StoryImage
    |> where(public_id: ^public_id)
    |> Repo.delete_all()
  end

  # PRIVATE FUNCTIONS
  ###################
  defp thread_query(query, [{:offset, offset}|opts], level), do: query
  |> offset(^offset)
  |> thread_query(opts, level)

  defp thread_query(query, [{:limit, limit}|opts], level), do: query
  |> limit(^limit)
  |> thread_query(opts, level)

  defp thread_query(query, [{:mode, :new}|opts], level), do: query
  |> order_by([c], desc: c.inserted_at)
  |> thread_query(opts, level)

  defp thread_query(query, [{:mode, _}|opts], level), do: query
  |> order_by([c], desc: c.score_private)
  |> thread_query(opts, level)

  defp thread_query(query, [], level) do
    user = Application.get_env(:gabbler_data, :user)

    query
    |> join(:left, [c], u in ^user, on: c.user_id == u.id)
    |> select([c, u], %{
      id: c.id,
      user_id: c.user_id, 
      room_id: c.room_id,
      parent_id: c.parent_id,
      parent_type: c.parent_type,
      body: c.body,
      age: c.age,
      hash: c.hash,
      score_public: c.score_public, 
      inserted_at: c.inserted_at,
      depth: type(^level, :integer), 
      name: u.name
    })
  end

  # Deprecate.. sweet query.. but your work never forgotten
  #defp thread_query(post_id_string, sort_modifier, limit_string, offset_string) do
  #  hard_limit = Integer.to_string(@thread_query_hard_limit)
  #  user_table = Application.get_env(:gabbler_data, :user).__schema__(:source)
  #
  # TODO: will refactor to something less fun but easier to cache in multiple batches
  # qry = "
  #    WITH RECURSIVE posts_r(id, user_id, room_id, parent_id, parent_type, body, age, hash, score_public, 
  #      score_private, inserted_at, depth, path) AS (
  #        (SELECT p.id, p.user_id, p.room_id, p.parent_id, p.parent_type, body, age, hash, score_public, 
  #          score_private, inserted_at, 1, ARRAY[#{sort_modifier}, EXTRACT(epoch FROM p.inserted_at)::bigint]
  #        FROM posts p
  #        WHERE p.parent_id = '#{post_id_string}' AND p.parent_type != 'room'
  #        LIMIT #{limit_string} OFFSET #{offset_string})
  #      UNION ALL
  #        SELECT p.id, p.user_id, p.room_id, p.parent_id, p.parent_type, p.body, p.age, p.hash, p.score_public, 
  #          p.score_private, p.inserted_at, pr.depth + 1, path || #{sort_modifier} || EXTRACT(epoch FROM p.inserted_at)::bigint
  #        FROM posts p, posts_r pr
  #        WHERE p.parent_id = pr.id AND p.parent_type != 'room'
  #      )
  #    SELECT psr.id, psr.user_id, psr.room_id, psr.parent_id, psr.parent_type, psr.body, psr.age, psr.hash, 
  #      psr.score_public, psr.score_private, psr.inserted_at, psr.depth, psr.path, u.name
  #    FROM posts_r psr LEFT JOIN #{user_table} u ON psr.user_id = u.id 
  #    ORDER BY path LIMIT #{hard_limit}
  #  "
  #
  #  res = Ecto.Adapters.SQL.query!(Repo, qry, [])
  #
  #  cols = Enum.map res.columns, &(String.to_atom(&1))
  #
  #  Enum.map(res.rows, fn row ->
      # Comment is a Post like struct but gives us some flexibility to differentiate
  #    struct(Comment, Enum.zip(cols, row))
  #  end)
  #end

  defp list(query, []), do: query |> Repo.all()

  defp list(query, [{:by_user, id}|opts]) do
    list(where(query, user_id: ^id), opts)
  end

  defp list(query, [{:by_room, id}|opts]) do
    query = query
    |> join(:left, [p], r in Room, on: p.room_id == r.id)
    |> where(parent_type: "room")
    |> where(parent_id: ^id)

    list(query, opts)
  end

  defp list(query, [{:only, :op}|opts]) do
    list(where(query, [p], p.parent_type == "room"), opts)
  end

  defp list(query, [{:only, :comment}|opts]) do
    list(where(query, [p], p.parent_type == "comment"), opts)
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