defmodule GabblerData.Repo.Migrations.StoryImages do
  use Ecto.Migration

  def change do
    create table(:story_images, primary_key: false) do
      add :public_id, :string, primary_key: true
      add :story_hash, :string
      add :url, :string
      add :thumb, :string
      add :story_order, :integer

      timestamps(type: :timestamptz)
    end

    create index(:story_images, [:story_hash])
    create index(:story_images, [:story_order])
  end


end
