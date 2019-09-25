defmodule GabblerData.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    # USERS
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :string
      add :confirmation_token, :string
      add :confirmed_at, :timestamptz
      add :confirmation_sent_at, :timestamptz
      add :reputation, :integer
      add :gifts, :integer
      add :moderating, {:array, :map}
      
      timestamps(type: :timestamptz)
    end
    create unique_index(:users, [:name])
    create unique_index(:users, [:email])

    # ROOMS
    create table(:rooms) do
      add :user_id_creator, :integer
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
    create index(:rooms, [:user_id_creator])
    create index(:rooms, [:age])

    # POSTS
    create table(:posts) do
      add :user_id_post, :integer
      add :title, :string, size: 350
      add :body, :string, size: 3800
      add :room_id, :integer
      add :parent_id, :integer
      add :parent_type, :string
      add :age, :integer
      add :hash, :string
      add :score_public, :integer
      add :score_private, :integer
      add :score_alltime, :integer

      timestamps(type: :timestamptz)
    end
    create index(:posts, [:user_id_post])
    create index(:posts, [:score_public])
    create index(:posts, [:score_private])
    create index(:posts, [:score_alltime])
    create index(:posts, [:hash])
    create index(:posts, [:room_id])
    create index(:posts, [:parent_id])
    create index(:posts, [:parent_type])
    create index(:posts, [:parent_type, :parent_id])

    create table(:post_metas) do
      add :user_id, :integer
      add :post_id, :integer
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
      add :post_id, :int

      timestamps(type: :timestamptz)
    end
    create index(:anonymous_posts, [:hash])
    create index(:anonymous_posts, [:post_id])

    # VOTES
    create table(:votes) do
      add :user_id, :string
      add :post_id, :integer
      add :vote, :integer

      timestamps(type: :timestamptz)
    end
    create unique_index(:votes, [:user_id, :post_id])
    create index(:votes, [:post_id])

    # MODERATOR LISTINGS
    create table(:moderator_listings) do
      add :user_id, :integer
      add :room_id, :integer
      add :type, :string

      timestamps(type: :timestamptz)
    end
    create unique_index(:moderator_listings, [:user_id, :room_id])
    create index(:moderator_listings, [:user_id])

    # USER SUBSCRIPTIONS
    create table(:user_subscriptions) do
      add :user_id, :integer
      add :room_id, :string
      add :type, :string

      timestamps(type: :timestamptz)
    end
    create unique_index(:user_subscriptions, [:user_id, :room_id])
    create index(:user_subscriptions, [:user_id])

    # USER ROOM ALLOWS
    create table(:user_room_allows) do
      add :user_id, :string
      add :room_id, :string

      timestamps(type: :timestamptz)
    end
    create unique_index(:user_room_allows, [:user_id, :room_id])
    create index(:user_room_allows, [:user_id])

    # REGISTERED BOTS
    create table(:registered_bots) do
      add :name, :string
      add :user_id, :string
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
