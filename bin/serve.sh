#!/usr/bin/env bash
#
# Start the local Jekyll dev server with live reload.
#
#   ./bin/serve.sh              # http://localhost:8080, live reload on :35729
#   ./bin/serve.sh 4000         # use a different port
#   ./bin/serve.sh --drafts     # extra flags are passed through to jekyll serve
#
# Equivalent one-liner:
#   bundle exec jekyll serve --livereload --port 8080
#
# Notes:
#   - Edits to files under _pages/, _posts/, _sass/, assets/, etc. rebuild and
#     refresh the browser automatically.
#   - Changes to _config.yml are NOT picked up: stop (ctrl-c) and restart.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

PORT=8080
EXTRA_ARGS=()

for arg in "$@"; do
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        PORT="$arg"
    else
        EXTRA_ARGS+=("$arg")
    fi
done

if ! command -v magick &>/dev/null && ! command -v convert &>/dev/null; then
    echo "warning: imagemagick not found — responsive .webp images will not be generated." >&2
    echo "         install it with: brew install imagemagick" >&2
fi

if ! bundle check &>/dev/null; then
    echo "Installing Ruby gems (bundle install)..."
    bundle install
fi

echo "Serving on http://localhost:${PORT}/ (live reload on :35729) — ctrl-c to stop"

export JEKYLL_ENV=development
# ${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"} rather than "${EXTRA_ARGS[@]}": macOS ships
# bash 3.2, where set -u treats an empty array expansion as an unbound variable.
exec bundle exec jekyll serve --livereload --port "$PORT" ${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"}
