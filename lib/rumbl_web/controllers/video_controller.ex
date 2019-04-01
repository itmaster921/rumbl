defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  plug :scrub_params, "video" when action in [:create, :update]
  plug :load_categories when action in [:new, :create, :edit, :update]

  alias Rumbl.Videos
  alias Rumbl.Videos.Category

  def index(conn, _params, user) do
    videos = Videos.list_videos(user)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, user) do
    changeset = 
      user
      |> Ecto.build_assoc(:videos)
      |> Videos.change_video()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    case Videos.create_video(video_params, user) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

    # Approach 2
    # changeset =
    #   user
    #   |> Ecto.build_assoc(:videos)
    #   |> Video.changeset(video_params)
      
    # case Repo.insert(changeset) do 
    #   {:ok, _video} ->
    #     conn
    #     |> put_flash(:info, "Video created successfully.") 
    #     |> redirect(to: video_path(conn, :index))
    #   {:error, changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}, user) do
    video = Videos.get_video!(id, user)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Videos.get_video!(id, user)
    changeset = Videos.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Videos.get_video!(id, user)

    case Videos.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = Videos.get_video!(id, user)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  # Every controller has its own default action function. 
  # It’s a plug that dispatches to the proper action at the 
  # end of the controller pipeline. overriding it to push 
  # current_user object as the third argument
  def action(conn, _) do
    apply(__MODULE__, action_name(conn), 
      [conn, conn.params, conn.assigns.current_user])  
  end

  defp load_categories(conn, _) do
    categories = Category.load_categories()
    assign(conn, :categories, categories)
  end
  
end
