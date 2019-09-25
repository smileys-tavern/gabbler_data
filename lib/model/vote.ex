defmodule GabblerData.Vote do
  use GabblerData.Data, :model

  schema "votes" do
    field :user_id, :string
    field :post_id, :integer
    field :vote, :string

    timestamps(type: :utc_datetime)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :post_id, :vote])
    |> validate_required([:user_id, :post_id, :vote])
    |> unique_constraint(:user_id, name: :votes_user_id_post_id_index)
  end
end