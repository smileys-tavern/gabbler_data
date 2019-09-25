defmodule GabblerData.Comment do
  use GabblerData.Data, :model

  schema "comments" do
    field :user_id_post, :integer
    field :title, :string
    field :body, :string
    field :room_id, :integer
    field :parent_id, :integer
    field :parent_type, :string
    field :age, :integer
    field :hash, :string
    field :vote_public, :integer
    field :vote_private, :integer
    field :vote_alltime, :integer
    field :depth, :integer
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :user_id_post, :title, :body, :room_id, :parent_id, :parent_type, 
      :age, :hash, :vote_public, :vote_private, :vote_alltime])
    |> validate_length(:body, max: 500)
  end
end
