#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.35.5"

if [ ! -d "$HOME/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1 "$HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

SUPABASE_URL_VALUE="${SUPABASE_URL:-}"
SUPABASE_ANON_KEY_VALUE="${SUPABASE_ANON_KEY:-}"

if [ -z "$SUPABASE_URL_VALUE" ] || [ -z "$SUPABASE_ANON_KEY_VALUE" ]; then
  echo "Warning: SUPABASE_URL or SUPABASE_ANON_KEY is not configured in Vercel."
fi

flutter pub get
flutter build web --release \
  --dart-define=SUPABASE_URL="$SUPABASE_URL_VALUE" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY_VALUE"
