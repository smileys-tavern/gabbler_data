defmodule GabblerData.AnonymousPost do
  use GabblerData.Data, :model

  schema "anonymous_posts" do
    field :hash, :string
    field :post_id, :binary_id
    
    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hash, :post_id])
    |> validate_required([:hash, :post_id])
  end
end