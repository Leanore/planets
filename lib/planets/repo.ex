defmodule Planets.Repo do
  use Ecto.Repo,
    otp_app: :planets,
    adapter: Ecto.Adapters.Postgres
end
