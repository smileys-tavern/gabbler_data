defmodule GabblerData.StoryImage do
  use GabblerData.Data, :model

  @primary_key false
  
  schema "story_images" do
    field :public_id, :string
    field :story_hash, :string
    field :url, :string
    field :thumb, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:public_id, :story_hash, :url, :thumb])
    |> validate_required([:public_id, :story_hash, :url], [:trim])
  end
end