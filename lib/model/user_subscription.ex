defmodule GabblerData.UserSubscription do
  use GabblerData.Data, :model

  schema "user_subscriptions" do
    field :user_id, :integer
    field :room_id, :string
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
  end
end
