defmodule GabblerData.User do
  use GabblerData.Data, :model

  alias Argon2

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :password_hash_confirm, :string, virtual: true
    field :reputation, :integer
    field :gifts, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :password_hash, :reputation, :gifts])
    |> validate_confirmation(:password_hash, message: "passwords do not match")
    |> validate_required([:name, :password_hash])
    |> validate_password(:password_hash)
    |> put_password_hash()
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:name)
    |> validate_length(:name, min: 2)
    |> validate_length(:name, max: 44)
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]+$/)
  end

  def mock_data() do
    %GabblerData.User{id: 1, name: "Captain Mock", email: "captain@mockshold.com", reputation: 10000, gifts: 10}
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password_hash: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> 
          []
        {:error, msg} -> 
          [{field, options[:message] || msg}]
      end
    end)
  end

  defp strong_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp strong_password?(_), do: {:error, "The password is too short"}

  #TODO: optionally validate email if emails are configured to be used
  #defp validate_email(changeset) do
  #  validate_format(changeset, :email, ~r/@/)
  #  |> validate_length(:email, max: 254)
  #  |> unique_constraint(:email)
  #end
end