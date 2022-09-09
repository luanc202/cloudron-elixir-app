FROM cloudron/base:3.2.0@sha256:ba1d566164a67c266782545ea9809dc611c4152e27686fd14060332dd88263ea

RUN mkdir -p /app/code

# install asdf
# RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# install dependencies for hex and phoenix
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    inotify-tools \
    gnupg \
    # erlang \
    && rm -rf /var/lib/apt/lists/*

 

# get Erlang 
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb

# install Elixir
RUN apt-get update -y
RUN apt-get install -y elixir

# install hex and phoenix
RUN mix local.hex --force

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


#create link for .env
RUN ln -sf /app/data/config.exs /app/code/config/config.exs

CMD [ "/app/code/start.sh" ]