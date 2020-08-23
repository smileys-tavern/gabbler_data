defmodule GabblerData.Repo.Migrations.PostMetaStory do
  use Ecto.Migration

  def change do
    alter table("post_metas") do
      add :story, :text
    end
  end
end
