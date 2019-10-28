defmodule GabblerData.Behaviour.LogicMeta do
  @moduledoc """
  These functions have to be implemented to guarantee Meta data is handled correctly by and for
  Gabbler Web
  """
  alias GabblerData.PostMeta


  @doc """
  Uploading of an image. This will be implemented once LiveView has their file upload functionality
  added. Takes image data such as that from a form, and the tags associated with the post in case the
  image is to be searchable.
  """
  @callback upload_image(%{}, String.t) :: {:ok, %{}} | {:error, String.t}

  @doc """
  Run through the tags and if they are of special significance, add to a list of actionable
  2-tuples
  """
  @callback process_tags(%PostMeta{}, String.t) :: [{}]

  @doc """
  Format the tags how they should be standardized across Web
  """
  @callback format_tags(String.t) :: String.t

  @doc """
  Filter the tags according to any project rules and return a list of surviving tags
  """
  @callback filter_tags(String.t | [String.t]) :: []
end