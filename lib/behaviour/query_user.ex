defmodule GabblerData.Behaviour.QueryUser do
  @moduledoc """
  The Gabbler User is any user. They all have logins but can have various permissions related to
  administration and moderation of rooms and posts.
  """
  alias GabblerData.User

  @doc """
  Attempt to create a User
  """
  @callback create(%{}) :: {:ok, %User{}} | {:error, %{}}

  @doc """
  Retrieve a single User record by ID or Email or Name
  """
  @callback get(Integer) :: %User{} | nil
  @callback get(String.t) :: %User{} | nil

  @doc """
  For updating the reputation level of a room. If not utilizing reputations, can simply
  return {:ok, %Room{}}
  """
  @callback authenticate(Integer, String.t) :: {:ok, %User{}} | {:error, Atom}
end