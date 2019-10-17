defmodule GabblerData.Behaviour.QuerySubscription do
  @moduledoc """
  The Gabbler User is any user. They all have logins but can have various permissions related to
  administration and moderation of rooms and posts.
  """
  alias GabblerData.{User, Room, UserSubscription}

  @doc """
  Subscribe a user to a room
  """
  @callback subscribe(%User{}, %Room{}) :: {:ok, %UserSubscription{}} | {:error, %{}}

  @doc """
  Reverse a subscription
  """
  @callback unsubscribe(%User{}, %Room{}) :: {:ok, %UserSubscription{}} | {:error, %{}}

  @doc """
  Check if a user is subscribed to a room
  """
  @callback subscribed?(%User{}, %Room{}) :: true | false

  @doc """
  List a users room subscriptions
  """
  @callback list(%User{}, List) :: List
end