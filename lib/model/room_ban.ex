defmodule GabblerData.RoomBan do
  use GabblerData.Data, :model

  @primary_key false

  schema "room_bans" do
    field :room_id, :binary_id, primary_key: true
    field :user_id, :binary_id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:room_id, :user_id])
    |> unique_constraint([:room_id, :user_id], name: :room_bans_pkey)
  end
end
