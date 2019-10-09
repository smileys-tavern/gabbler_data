defmodule GabblerData.Query.User do
  @moduledoc """
  Coverage for queries involving a gabbler User
  """
  @behaviour GabblerData.Behaviour.QueryUser

  alias Argon2

  alias GabblerData.{Repo, User}


  @impl true
  def create(changeset), do: Repo.insert(changeset)

  @impl true
  def get(id) when is_integer(id), do: User |> Repo.get_by(id: id)
  def get(name) when is_binary(name), do: User |> Repo.get_by(name: name)

  @impl true
  def authenticate(name, plain_text_password) do
    case get(name) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}
      user ->
        if Argon2.verify_pass(plain_text_password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end