defmodule GabblerData.Behaviour.QueryUser do
  @moduledoc """
  The Gabbler User is any user. They all have logins but can have various permissions related to
  administration and moderation of rooms and posts.
  """

  @doc """
  Attempt to create a User
  """
  @callback create(%{}) :: {:ok, %{}} | {:error, %{}}

  @doc """
  Retrieve a single User record by ID or Email or Name
  """
  @callback get(String.t) :: %{} | nil
  @callback get_by_name(String.t) :: %{} | nil
end