FROM cloudron/base:3.2.0@sha256:ba1d566164a67c266782545ea9809dc611c4152e27686fd14060332dd88263ea

RUN mkdir -p /app/code
WORKDIR /app/code

# copy code
COPY assets/ /app/code/
COPY config/ /app/code/
COPY lib/ /app/code/
COPY priv/ /app/code/
COPY test/ /app/code/
COPY .formatter.exs /app/code/
COPY mix.exs /app/code/
COPY mix.lock /app/code/
COPY config/config-template.exs /app/data/config.exs
COPY start.sh /app/code/

# install asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# add asdf to bash
RUN echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc

# install erlang and elixir
RUN asdf install erlang 25.0.4
RUN asdf install elixir 1.12.1

# install dependencies for hex and phoenix
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    inotify-tools \
    && rm -rf /var/lib/apt/lists/*
# install hex and phoenix
RUN mix local.hex

#create link for .env
RUN ln -sf /app/data/config.exs /app/code/config/config.exs

CMD [ "/app/code/start.sh" ]