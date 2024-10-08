# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Munch.Repo.insert!(%Munch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Munch.Repo.insert!(%Munch.Restaurants.Restaurant{
  name: "Mappen",
  address: "shop 11/537-551 George St, Sydney NSW 2000, Australia"
})

Munch.Repo.insert!(%Munch.Restaurants.Restaurant{
  name: "Chaco Ramen",
  address: "238 Crown St, Darlinghurst NSW 2010, Australia"
})

Munch.Repo.insert!(%Munch.Restaurants.Restaurant{
  name: "Emperor's Garden Cakes & Bakery",
  address: "75 Dixon St, Haymarket NSW 2000, Australia"
})

Munch.Repo.insert!(%Munch.Restaurants.Restaurant{
  name: "Ice Kirin Bar",
  address: "486/488 Kent St, Sydney NSW 2000, Australia"
})

Munch.Repo.insert!(%Munch.Restaurants.Restaurant{
  name: "Pho Pasteur",
  address: "709 George St, Haymarket NSW 2000, Australia"
})
