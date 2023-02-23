FROM bitwalker/alpine-elixir:1.14 as build

COPY . .

RUN mix deps.get && mix compile

CMD elixir --sname app -S mix run --no-halt

EXPOSE 4001
