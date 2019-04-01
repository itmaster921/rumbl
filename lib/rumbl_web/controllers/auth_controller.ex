defmodule Rumbl.AuthController do
  use RumblWeb, :controller
  require Logger

  def login(conn, user) do
    Logger.info  "Logging this text!"
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true) 
  end
end