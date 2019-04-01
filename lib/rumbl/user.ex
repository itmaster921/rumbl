defmodule Rumbl.User do
  use RumblWeb, :model

  schema "users" do
    field :name,          :string
    field :username,      :string
    field :password,      :string, virtual: true
    field :password_hash, :string

    has_many :videos, Rumbl.Videos.Video

    timestamps
  end

  #CHANGE: Passing :empty is deprecated, use :invalid instead
  def changeset(model, params \\ :invalid) do
    model
    #CHANGE: cast/4 is deprecates, use cast/3 like below
    |> cast(params, [:name, :username])
    #CHANGE: Use validate required for presence
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    # Add a validation error message for the exception
    |> unique_constraint(:username)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    #CHANGE: use cast/3 instead of cast/4
    |> cast(params, [:password])
    |> validate_length(:password, min: 4, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end