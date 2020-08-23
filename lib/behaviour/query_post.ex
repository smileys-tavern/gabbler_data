defmodule GabblerData.Behaviour.QueryPost do
  @moduledoc """
  The Gabbler Post is primarily a text post that users need to be able to create. They have meta data and 
  votes associated with them. They also have comments associated with them and a comment is a form of
  simpler post, giving the recursive structure of the application. Post also covers Post Meta which associated
  with posts (all Posts have meta information attached)
  """
  alias GabblerData.{Post, PostMeta, StoryImage}

  @doc """
  Retrieve a single Post record by ID or Hash
  """
  @callback get(String.t) :: %Post{} | nil
  @callback get_by_hash(String.t) :: %Post{} | nil
  @callback get_meta(%Post{}) :: %PostMeta{} | nil

  @doc """
  Retrieve a list of posts. Expects a keyword list of options to constrain the results
  """
  @callback list(List) :: [%Post{}]

  @doc """
  Retrieve a map of meta information keyed by the posts
  """
  @callback map_meta([%Post{}]) :: %{}

  @doc """
  Retrieve a map of rooms keyed by the posts
  """
  @callback map_rooms([%Post{}]) :: %{}

  @doc """
  Retrieve a map of users keyed by the posts
  """
  @callback map_users([%Post{}]) :: %{}

  @doc """
  Retrieve stories for a post
  """
  @callback get_story_images(%PostMeta{}) :: [%StoryImage{}]

  @doc """
  Create a Post using the Post and PostMeta changesets.
  """
  @callback create(%{}, %{}) :: {:ok, {%Post{}, %PostMeta{}}} | {:error, %{}}

  @doc """
  Create a story image associated with a post
  """
  @callback create_story_image(%{}) :: {:ok, %StoryImage{}} | {:error, %{}}

  @doc """
  Delete a stories image by it's public id
  """
  @callback delete_story_image(String.t) :: {:ok, %{}}

  @doc """
  Create a reply, which is a subset of Post and has different field requirements
  """
  @callback create_reply(%{}) :: {:ok, %Post{}} | {:error, %{}}

  @doc """
  Update a Post. Unlike create, this can be updated individually.
  """
  @callback update(%{}) :: {:ok, %Post{}} | {:error, %{}}

  @doc """
  Updates a Posts Meta. Unlike create, this can be updated separately.
  """
  @callback update_meta(%{}) :: {:ok, %PostMeta{}} | {:error, %{}}

  @doc """
  Move the score of a post up or down. Takes a public and private amount. Public score should be
  incremented 1 or -1 generally and private can be any integer based on scoring algorithm.
  """
  @callback increment_score(%Post{}, Integer, Integer) :: {:ok, %Post{}} | {:error, %{}}

  @doc """
  Return amount of comments associated with a post (ok to return zero if non-top level post passed)
  """
  @callback comment_count(%Post{}) :: Integer

  @doc """
  Uses whatever pagination logic chosen to return the amount of pages of comments there are
  """
  @callback page_count(%Post{}) :: Integer

  @doc """
  Return a posts recusive comment thread. Takes a parent post and atom representing the query mode.
  Recommendation: care not be it ugly as sin; optimize and cache as a priority.
  NOTE: the thread should be returned with a depth value for each comment to support the recursive
  nature of gabbler threads
  """
  @callback thread(%Post{}, Atom) :: :ok
end