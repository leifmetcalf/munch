defmodule Munch.Repo do
  use Ecto.Repo,
    otp_app: :munch,
    adapter: Ecto.Adapters.Postgres
end
