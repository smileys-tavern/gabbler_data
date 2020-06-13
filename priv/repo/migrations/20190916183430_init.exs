defmodule GabblerData.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    # ROOMS
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :binary_id
      add :name, :string
      add :title, :string
      add :description, :string
      add :type, :string
      add :reputation, :integer
      add :age, :integer

      timestamps(type: :timestamptz)
    end
    create unique_index(:rooms, [:name])
    create index(:rooms, [:type])
    create index(:rooms, [:user_id])
    create index(:rooms, [:age])

    # POSTS
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :binary_id
      add :title, :string, size: 350
      add :body, :text
      add :room_id, :binary_id
      add :parent_id, :binary_id
      add :parent_type, :string
      add :age, :integer
      add :hash, :string
      add :score_public, :integer
      add :score_private, :integer
      add :score_alltime, :integer

      timestamps(type: :timestamptz)
    end
    create index(:posts, [:user_id])
    create index(:posts, [:score_public])
    create index(:posts, [:score_private])
    create index(:posts, [:score_alltime])
    create index(:posts, [:hash])
    create index(:posts, [:room_id])
    create index(:posts, [:parent_id])
    create index(:posts, [:parent_type])
    create index(:posts, [:parent_type, :parent_id])

    create table(:post_metas) do
      add :user_id, :binary_id
      add :post_id, :binary_id
      add :link, :string
      add :image, :string
      add :thumb, :string
      add :tags, :string

      timestamps(type: :timestamptz)
    end
    create unique_index(:post_metas, [:post_id])
    create index(:post_metas, [:user_id])
    create index(:post_metas, [:link])

    create table(:anonymous_posts) do
      add :hash, :string
      add :post_id, :binary_id

      timestamps(type: :timestamptz)
    end
    create index(:anonymous_posts, [:hash])
    create index(:anonymous_posts, [:post_id])

    # VOTES
    create table(:votes) do
      add :user_id, :binary_id
      add :post_id, :binary_id
      add :vote, :integer

      timestamps(type: :timestamptz)
    end
    create unique_index(:votes, [:user_id, :post_id])
    create index(:votes, [:post_id])

    # MODERATOR LISTINGS
    create table(:user_moderating) do
      add :user_id, :binary_id
      add :room_id, :binary_id
      add :type, :string

      timestamps(type: :timestamptz)
    end
    create unique_index(:user_moderating, [:user_id, :room_id])
    create index(:user_moderating, [:user_id])

    # USER SUBSCRIPTIONS
    create table(:user_subscriptions) do
      add :user_id, :binary_id
      add :room_id, :binary_id
      add :type, :string

      timestamps(type: :timestamptz)
    end
    create unique_index(:user_subscriptions, [:user_id, :room_id])
    create index(:user_subscriptions, [:user_id])

    # USER ROOM ALLOWS
    create table(:user_room_allows) do
      add :user_id, :binary_id
      add :room_id, :binary_id

      timestamps(type: :timestamptz)
    end
    create unique_index(:user_room_allows, [:user_id, :room_id])
    create index(:user_room_allows, [:user_id])

    # REGISTERED BOTS
    create table(:registered_bots) do
      add :name, :string
      add :user_id, :binary_id
      add :type, :string
      add :callback_module, :string

      timestamps(type: :timestamptz)
    end
    create unique_index(:registered_bots, [:name])
    create index(:registered_bots, [:type])

    create table(:registered_bot_metas) do
      add :bot_id, :string
      add :type, :string
      add :meta, :string

      timestamps(type: :timestamptz)
    end
    create index(:registered_bot_metas, [:bot_id])
    create index(:registered_bot_metas, [:type])
  end
end
