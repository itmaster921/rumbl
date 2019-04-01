defmodule Rumbl.Videos.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Rumbl.Repo
  alias Rumbl.Videos.Category


  schema "categories" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def load_categories() do
    query =
      Category
      |> Category.aplhabetical
      |> Category.names_and_ids
    Repo.all query
  end

  @doc false
  def aplhabetical(query) do
    from c in query, order_by: c.name
  end

  @doc false
  def names_and_ids(query) do
    from c in query, select: {c.name, c.id}
  end
end
