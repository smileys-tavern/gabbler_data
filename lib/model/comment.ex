defmodule GabblerData.Comment do
  use GabblerData.Data, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "posts" do
    field :user_id, :binary_id
    field :title, :string
    field :body, :string
    field :room_id, :binary_id
    field :parent_id, :binary_id
    field :parent_type, :string
    field :age, :integer
    field :hash, :string
    field :hash_op, :string, virtual: true
    field :comments, :integer, virtual: true
    field :score_public, :integer
    field :score_private, :integer
    field :score_alltime, :integer
    field :depth, :integer
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :user_id, :title, :body, :room_id, :parent_id, :parent_type, 
      :age, :hash, :score_public, :score_private, :score_alltime])
    |> validate_required([:user_id, :body, :parent_id], [:trim])
    |> validate_length(:body, min: 2)
    |> validate_length(:body, max: 500)
  end
end
