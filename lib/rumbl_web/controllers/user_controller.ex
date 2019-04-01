defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  # import Phoenix.Controller
  
  require Logger
  plug :authenticate_user when action in [:index, :show]

  alias Rumbl.Repo
  alias Rumbl.User
  # alias Rumbl.Router.Helpers

  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users        
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} -> 
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
      end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)
    render conn, "show.html", user: user
  end

  #### Private functions ####

  # def authenticate_user(conn, _opts) do
  #   Logger.debug "CONN IN AUTHENTICATE #{inspect conn}"
  #   if conn.assigns.current_user do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You must be logged in to access this page.")
  #     |> redirect(to: Helpers.page_path(conn, :index))
  #     |> halt()
  #   end
  # end
end