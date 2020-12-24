defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Forum.Topic

  def index(conn, _params) do
    topics = Discuss.Repo.all(Topic)
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)
    case Discuss.Repo.insert(changeset) do
      {:ok, post} -> IO.inspect(post)
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end
end
