FROM elixir:1.5

ADD . /app

WORKDIR /app

RUN mix local.rebar --force && mix local.hex --force && mix deps.get

RUN MIX_ENV=prod mix release --env=prod

EXPOSE 4000

ENTRYPOINT ["/app/_build/prod/rel/mailchimp_proxy/bin/mailchimp_proxy", "foreground"]

CMD ["/app/_build/prod/rel/mailchimp_proxy/bin/mailchimp_proxy", "foreground"]
