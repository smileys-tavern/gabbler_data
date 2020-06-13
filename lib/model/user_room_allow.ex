defmodule GabblerData.UserRoomAllow do
  use GabblerData.Data, :model

  schema "user_room_allows" do
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
    |> unique_constraint(:user_id, :user_room_allows_user_id_room_id_index)
  end
end
