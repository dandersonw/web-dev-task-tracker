#!/bin/bash

export MIX_ENV=prod
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."
mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

echo "Generating release..."
mix release
mix ecto.reset

sudo runuser -l phoenix -c 'cp -r . /home/phoenix/task-tracker-1'
sudo systemctl restart tasktracker1
