defmodule GabblerData.Query.User do
  @moduledoc """
  Coverage for queries involving a gabbler User. User schema is defined by the calling
  application so is returned via config
  """
  @behaviour GabblerData.Behaviour.QueryUser

  alias GabblerData.Repo


  @impl true
  def create(changeset), do: Repo.insert(changeset)

  @impl true
  def get(id), do: _user_repo() |> Repo.get_by(id: id)

  @impl true
  def get_by_name(name), do: _user_repo() |> Repo.get_by(name: name)

  defp _user_repo(), do: Application.get_env(:gabbler_data, :user)
end