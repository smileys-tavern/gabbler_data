defmodule GabblerData.RegisteredBotMeta do
  use GabblerData.Data, :model

  schema "registered_bot_metas" do
    field :bot_id, :string
    field :type, :string
    field :meta, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:bot_id, :type, :meta])
    |> validate_required([:bot_id, :type, :meta])
  end
end