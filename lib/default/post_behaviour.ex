defmodule GabblerData.Default.PostBehaviour do
  @moduledoc """
  The Gabbler Post is primarily a text post that users need to be able to create. They have meta data and 
  votes associated with them. They also have comments associated with them and a comment is a form of
  simpler post, giving the recursive structure of the application. Post also covers Post Meta which associated
  with posts (all Posts have meta information attached)
  """
  alias GabblerData.{Post, PostMeta}

  @doc """
  Retrieve a single Post record by ID or Hash
  """
  @callback get(Integer) :: %Post{} | nil
  @callback get(String.t) :: %Post{} | nil

  @doc """
  Retrieve a list of posts. Expects a keyword list of options to constrain the results
  """
  @callback list(List) :: [%Post{}]

  @doc """
  Retrieve a map of meta information keyed by the posts
  """
  @callback map_meta([%Post{}]) :: %{}

  @doc """
  Create a Post using the Post and PostMeta changesets.
  """
  @callback create(%{}, %{}) :: {:ok, {%Post{}, %PostMeta{}}} | {:error, %{}}

  @doc """
  Update a Post. Unlike create, this can be updated individually.
  """
  @callback update(%{}) :: {:ok, %Post{}} | {:error, %{}}

  @doc """
  Updates a Posts Meta. Unlike create, this can be updated separately.
  """
  @callback update_meta(%{}) :: {:ok, %PostMeta{}} | {:error, %{}}
end