#!/bin/bash

flutter config --no-analytics
flutter pub global activate melos
echo "$HOME/.pub-cache/bin" >> $GITHUB_PATH