defmodule Moochat.Repo do
  use Ecto.Repo,
    otp_app: :moochat,
    adapter: Ecto.Adapters.Postgres
end
