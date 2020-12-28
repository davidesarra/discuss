defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.Forum.{Topic, Comment}

  def join("comments:" <> topic_id, _message, socket) do
    topic_id = String.to_integer(topic_id)
    topic =
      Topic
      |> Discuss.Repo.get(topic_id)
      |> Discuss.Repo.preload(:comments)
    socket = assign(socket, :topic, topic)
    {:ok, %{comments: topic.comments}, socket}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    changeset =
      topic
      |> Ecto.build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    case Discuss.Repo.insert(changeset) do
      {:ok, _comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, %{error: %{errors: changeset}}, socket}
    end
  end
end
