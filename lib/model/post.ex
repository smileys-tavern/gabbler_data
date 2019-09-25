defmodule GabblerData.Post do
  use GabblerData.Data, :model

  schema "posts" do
    field :user_id_post, :integer
    field :title, :string
    field :body, :string
    field :room_id, :integer
    field :parent_id, :integer
    field :parent_type, :string
    field :age, :integer
    field :hash, :string
    field :score_public, :integer, default: 1
    field :score_private, :integer, default: 1
    field :score_alltime, :integer, default: 1

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :user_id_post, :title, :body, :room_id, :parent_id, :parent_type, 
      :age, :hash, :score_public, :score_private, :score_alltime])
    |> validate_required([:title])
    |> validate_length(:title, min: 2)
    |> validate_length(:title, max: 350)
    |> validate_format(:title, ~r/^[a-zA-Z0-9 \-\–\.,\/'’‘%|?!:\)\(#&;]+$/)
    |> validate_length(:body, max: 11099)
  end

  def mock_data() do
    [
      %GabblerData.Post{
        id: 1,
        user_id_post: 1,
        title: "Hello World, I am a test post",
        body: "I am the body of the post saying hello to the world",
        room_id: 1,
        parent_id: 1,
        parent_type: "room",
        age: 0,
        hash: "TEST-1",
        score_public: 7,
        score_private: 7,
        score_alltime: 7,
        inserted_at: Timex.now()
      },
      %GabblerData.Post{
        id: 2,
        user_id_post: 1,
        title: "Hello World, I am a test post",
        body: "I am the body of the post saying hello to the world",
        room_id: 1,
        parent_id: 1,
        parent_type: "room",
        age: 0,
        hash: "TEST-2",
        score_public: 5,
        score_private: 7,
        score_alltime: 5,
        inserted_at: Timex.now()
      },
      %GabblerData.Post{
        id: 3,
        user_id_post: 1,
        title: "Hello World, I am a test post",
        body: "I am the body of the post saying hello to the world",
        room_id: 1,
        parent_id: 1,
        parent_type: "room",
        age: 0,
        hash: "TEST-1",
        score_public: 7,
        score_private: 7,
        score_alltime: 7,
        inserted_at: Timex.now()
      }
    ]
  end
end