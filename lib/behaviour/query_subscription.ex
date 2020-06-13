defmodule GabblerData.Behaviour.QuerySubscription do
  @moduledoc """
  The Gabbler User is any user. They all have logins but can have various permissions related to
  administration and moderation of rooms and posts.
  """
  alias GabblerData.{Room, UserSubscription}

  @doc """
  Subscribe a user to a room
  """
  @callback subscribe(%{}, %Room{}) :: {:ok, %UserSubscription{}} | {:error, %{}}

  @doc """
  Reverse a subscription
  """
  @callback unsubscribe(%{}, %Room{}) :: {:ok, %UserSubscription{}} | {:error, %{}}

  @doc """
  Check if a user is subscribed to a room
  """
  @callback subscribed?(%{}, %Room{}) :: true | false

  @doc """
  List a users room subscriptions
  """
  @callback list(%{}, List) :: List
end