# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rumbl.Repo.insert!(%Rumbl.SomeSchema{})
#


alias Rumbl.Repo
alias Rumbl.Videos.Category

for category <- ~w(Action Drama Romance Comdedy Sci-Fi) do
  Repo.get_by(Category, name: category) ||
    Repo.insert!(%Category{name: category})
end