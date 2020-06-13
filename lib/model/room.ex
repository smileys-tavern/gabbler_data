defmodule GabblerData.Room do
  use GabblerData.Data, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "rooms" do
    field :name, :string
    field :user_id, :binary_id
    field :title, :string
    field :description, :string
    field :reputation, :integer
    field :type, :string
    field :age, :integer

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id, :title, :description, :type, :age, :reputation])
    |> unique_constraint(:name)
    |> validate_required([:name, :user_id, :title, :description, :type, :age, :reputation])
    |> validate_length(:name, min: 2)
    |> validate_length(:name, max: 44)
    |> validate_format(:name, ~r/^[a-zA-Z0-9_]+$/)
    |> validate_length(:title, max: 250)
    |> validate_length(:description, max: 500)
    |> validate_inclusion(:age, 0..180)
    |> validate_inclusion(:type, ["public", "private", "restricted"])
  end
end