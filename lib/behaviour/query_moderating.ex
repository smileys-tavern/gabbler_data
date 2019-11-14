defmodule GabblerData.Behaviour.QueryModerating do
  @moduledoc """
  The Gabbler User is any user. They all have logins but can have various permissions related to
  administration and moderation of rooms and posts.
  """
  alias GabblerData.{User, Room, UserModerating}

  @doc """
  Subscribe a user to a room
  """
  @callback moderate(%User{}, %Room{}) :: {:ok, %UserModerating{}} | {:error, %{}}

  @doc """
  Reverse a subscription
  """
  @callback remove_moderate(%User{}, %Room{}) :: {:ok, %UserModerating{}} | {:error, %{}}

  @doc """
  Check if a user is subscribed to a room
  """
  @callback moderating?(%User{}, %Room{}) :: true | false

  @doc """
  List a user or rooms moderation list
  """
  @callback list(%User{}, List) :: List

  @callback list(%Room{}, List) :: List
end