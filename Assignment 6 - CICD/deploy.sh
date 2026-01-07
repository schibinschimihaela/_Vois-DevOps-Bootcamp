#!/bin/bash

APP_DIR=~/python-app

mkdir -p $APP_DIR
cd $APP_DIR

unzip -o app.zip

pip3 install -r requirements.txt

pkill -f app.py || true
nohup python3 app.py > app.log 2>&1 &
