defimpl FunWithFlags.Actor, for: BitString do
  def id(str) do
    str
  end
end

defmodule PlausibleWeb.Api.ExternalController do
  use PlausibleWeb, :controller
  require Logger

  def event(conn, _params) do
    with {:ok, ingestion_request} <- Plausible.Ingestion.Request.build(conn),
         _ <- Sentry.Context.set_extra_context(%{request: ingestion_request.params}),
         :ok <- Plausible.Ingestion.add_to_buffer(ingestion_request) do
      conn |> put_status(202) |> text("ok")
    else
      {:error, :invalid_json} ->
        conn
        |> put_status(400)
        |> json(%{errors: %{request: "Unable to parse request body as json"}})

      {:error, errors} ->
        conn |> put_status(400) |> json(%{errors: errors})
    end
  end

  def error(conn, _params) do
    Sentry.capture_message("JS snippet error")
    send_resp(conn, 200, "")
  end

  def health(conn, _params) do
    postgres_health =
      case Ecto.Adapters.SQL.query(Plausible.Repo, "SELECT 1", []) do
        {:ok, _} -> "ok"
        e -> "error: #{inspect(e)}"
      end

    clickhouse_health =
      case Ecto.Adapters.SQL.query(Plausible.ClickhouseRepo, "SELECT 1", []) do
        {:ok, _} -> "ok"
        e -> "error: #{inspect(e)}"
      end

    status =
      case {postgres_health, clickhouse_health} do
        {"ok", "ok"} -> 200
        _ -> 500
      end

    put_status(conn, status)
    |> json(%{
      postgres: postgres_health,
      clickhouse: clickhouse_health
    })
  end

  def info(conn, _params) do
    build_metadata = System.get_env("BUILD_METADATA", "{}") |> Jason.decode!()

    geo_database =
      case Geolix.metadata(where: :geolocation) do
        %{database_type: type} ->
          type

        _ ->
          "(not configured)"
      end

    info = %{
      geo_database: geo_database,
      build: %{
        version: get_in(build_metadata, ["labels", "org.opencontainers.image.version"]),
        commit: get_in(build_metadata, ["labels", "org.opencontainers.image.revision"]),
        created: get_in(build_metadata, ["labels", "org.opencontainers.image.created"]),
        tags: get_in(build_metadata, ["tags"])
      }
    }

    json(conn, info)
  end
end
