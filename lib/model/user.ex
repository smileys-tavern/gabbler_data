defmodule GabblerData.User do
  use GabblerData.Data, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string
    field :reputation, :integer
    field :gifts, :integer

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :email, :password_hash, :reputation, :gifts])
    |> validate_required([:name])
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
end