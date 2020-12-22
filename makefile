PHOENIX_VERSION=1.2.5
POSTGRES_VERSION=13.1

install:
	mix local.rebar --force && \
	mix deps.get

tests:
	mix test

build-docs:
	mix docs

elixir-shell:
	iex -S mix

postgres-run:
	mkdir -p .postgres && \
	docker run \
		--rm \
		--name docker-postgres-$(POSTGRES_VERSION) \
		-e POSTGRES_PASSWORD=postgres \
		-d \
		-p 5432:5432 \
		-v $$(pwd)/.postgres:/var/lib/postgresql/data postgres:$(POSTGRES_VERSION)

postgres-shell:
	docker exec -it docker-postgres-$(POSTGRES_VERSION) \
		psql -h localhost -U postgres -d postgres

ecto-create-migration:
	mix ecto.gen.migration $(MIGRATION_NAME)

ecto-migrate:
	mix ecto.migrate

project-scaffolding:
	mix phx.new $(PROJECT)

project-setup:
	mix local.hex && \
	mix archive.install hex phx_new $(PHOENIX_VERSION)
