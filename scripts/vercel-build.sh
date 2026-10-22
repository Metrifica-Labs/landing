#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.35.5"

if [ ! -d "$HOME/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1 "$HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

# API da landing (leads + cases) roda na PROD: /opt/metrifica-landing-api (ver server/).
API_URL_VALUE="${API_URL:-https://api.metrifica.com.br/landing}"

flutter pub get
flutter build web --release --dart-define=API_URL="$API_URL_VALUE"

# Tower landing (React/Vite) is served at /tower next to the Flutter app.
npm ci --prefix tower
npm run build --prefix tower
rm -rf build/web/tower
cp -r tower/dist build/web/tower
