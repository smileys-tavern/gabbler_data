defmodule GabblerData.RoomBan do
  use GabblerData.Data, :model

  schema "room_bans" do
    field :room_id, :binary_id
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:room_id, :user_id])
  end
end
