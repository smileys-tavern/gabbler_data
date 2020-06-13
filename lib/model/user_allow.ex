defmodule GabblerData.UserAllow do
  use GabblerData.Data, :model

  schema "user_allows" do
    field :user_id, :binary_id
    field :room_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
  end
end
