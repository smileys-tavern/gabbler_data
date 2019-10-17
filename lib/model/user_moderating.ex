defmodule GabblerData.UserModerating do
  use GabblerData.Data, :model

  schema "user_moderating" do
    field :user_id, :integer
    field :room_id, :integer
    field :type, :string

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :room_id, :type])
    |> validate_required([:user_id, :room_id, :type])
    |> unique_constraint(:user_id, name: :user_moderating_user_id_room_id_index)
  end
end
