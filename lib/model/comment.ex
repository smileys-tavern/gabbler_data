defmodule GabblerData.Comment do
  use GabblerData.Data, :model

  schema "posts" do
    field :user_id_post, :integer
    field :title, :string
    field :body, :string
    field :room_id, :integer
    field :parent_id, :integer
    field :parent_type, :string
    field :age, :integer
    field :hash, :string
    field :hash_op, :string, virtual: true
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
      :user_id_post, :title, :body, :room_id, :parent_id, :parent_type, 
      :age, :hash, :score_public, :score_private, :score_alltime])
    |> validate_required([:user_id_post, :body, :parent_id], [:trim])
    |> validate_length(:body, min: 2)
    |> validate_length(:body, max: 500)
  end
end
