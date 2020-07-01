defmodule GabblerData.Behaviour.QueryRoom do
  @moduledoc """
  The Gabbler Room is an area of thematic content served at [website url]/r/[room name]. This
  set of behaviors must be implemented by the data dependency for querying Rooms. This behavior
  should be used as a dependency by any data library wishing to implement Gabbler's room functionality.
  """
  alias GabblerData.{Room, UserRoomAllow, RoomBan}

  @doc """
  Retrieve a single Room record by ID or Name
  """
  @callback get(String.t) :: %Room{} | nil
  @callback get_by_name(String.t) :: %Room{} | nil

  @doc """
  Retrieve a list of rooms. Expects a keyword list of options to constrain the results
  """
  @callback list(List) :: [%Room{}]

  @doc """
  For updating the reputation level of a room. If not utilizing reputations, can simply
  return {:ok, %Room{}}
  """
  @callback increment_reputation(%Room{}, Integer) :: {:ok, %Room{}} | {:error, %{}}

  @doc """
  Create a room using the mapped fields and values
  """
  @callback create(%{}) :: {:ok, %Room{}} | {:error, %{}}

  @doc """
  Update a Room
  """
  @callback update(%Room{}) :: {:ok, %Room{}} | {:error, %{}}

  @doc """
  Permanently ban a user from a room. Takes a room id and a user id
  """
  @callback ban_for_life(String.t, String.t) :: {:ok, %RoomBan{}} | {:error, %{}}

  @doc """
  Unban a user despite it being a permanent ban
  """
  @callback unban(String.t, String.t) :: {:ok, %RoomBan{}} | {:error, %{}}

  @callback banned?(String.t, String.t) :: true | false

  @doc """
  Check to see if user is in an allow list for (assumadely) private rooms
  """
  @callback allow_list?(String.t, String.t) :: true | false

  @callback add_to_allow_list(String.t, String.t) :: {:ok, %UserRoomAllow{}} | {:error, %{}}

  @callback remove_from_allow_list(String.t, String.t) :: {:ok, %UserRoomAllow{}} | {:error, %{}}
end