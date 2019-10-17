defmodule GabblerData.RegisteredBot do
  use GabblerData.Data, :model

  schema "registered_bots" do
    field :name, :string
    field :user_id, :integer
    field :type, :string
    field :callback_module, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id, :type, :callback_module])
    |> validate_required([:name, :type])
  end
end