defmodule GabblerData.PostMeta do
  use GabblerData.Data, :model

  schema "post_metas" do
    field :user_id, :binary_id
    field :post_id, :binary_id
    field :link, :string
    field :image, :string
    field :thumb, :string
    field :tags, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :post_id, :link, :image, :thumb, :tags])
    |> validate_required([:user_id])
    |> validate_length(:tags, max: 50)
    |> validate_format(:tags, ~r/^[a-zA-Z0-9, :]+$/)
    |> validate_format(:link, ~r/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/)
  end

  def mock_data() do
    %{
      1 => %GabblerData.PostMeta{user_id: "1", post_id: "1", thumb: "img01.deviantart.net/c6fd/i/2009/342/8/4/final_fantasy_white_mage_lego_by_drsparc.jpg"},
      2 => %GabblerData.PostMeta{user_id: "1", post_id: "1", tags: "test tag, tag two"},
      3 => %GabblerData.PostMeta{user_id: "1", post_id: "1", link: "https://test.com"}
    }
  end

  # 
end
