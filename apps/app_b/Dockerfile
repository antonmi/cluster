FROM elixir:1.14.3 as build

COPY . .

RUN mix local.hex --force && mix deps.get && mix compile

CMD elixir --sname b -S mix run --no-halt

EXPOSE 4001
