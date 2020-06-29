defmodule GabblerData.Repo.Migrations.BanForLifeTable do
  use Ecto.Migration

  def change do
    create table(:room_bans, primary_key: false) do
      add :room_id, :binary_id, primary_key: true
      add :user_id, :binary_id, primary_key: true

      timestamps(type: :timestamptz)
    end
  end
end
