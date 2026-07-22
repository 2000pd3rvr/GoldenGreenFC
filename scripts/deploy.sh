#!/usr/bin/env bash
# Deploy GoldenGreenFC: bump sub-version, commit, tag, push GitHub + Hugging Face Space.
# Usage:
#   ./scripts/deploy.sh              # patch bump (1.0.0 -> 1.0.1)
#   ./scripts/deploy.sh minor|major
#   ./scripts/deploy.sh --no-bump    # deploy current VERSION as-is (first release)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

GH_USER="${GH_USER:-2000pd3rvr}"
HF_USER="${HF_USER:-0001AMA}"
REPO_NAME="${REPO_NAME:-GoldenGreenFC}"
KIND="${1:-patch}"

if [[ "${KIND}" == "--no-bump" ]]; then
  VERSION="$(python3 scripts/bump_version.py --sync-only)"
else
  VERSION="$(python3 scripts/bump_version.py "${KIND}")"
fi

echo "Deploying ${REPO_NAME} v${VERSION}"

# Ensure git repo
if [[ ! -d .git ]]; then
  git init -b main
fi

# Remotes (username-only URLs; tokens via askpass / env)
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "https://${GH_USER}@github.com/${GH_USER}/${REPO_NAME}.git"
else
  git remote add origin "https://${GH_USER}@github.com/${GH_USER}/${REPO_NAME}.git"
fi
if git remote get-url hf >/dev/null 2>&1; then
  git remote set-url hf "https://${HF_USER}@huggingface.co/spaces/${HF_USER}/${REPO_NAME}"
else
  git remote add hf "https://${HF_USER}@huggingface.co/spaces/${HF_USER}/${REPO_NAME}"
fi

askpass_script="$(mktemp)"
trap 'rm -f "$askpass_script"' EXIT
cat > "$askpass_script" <<'ASKPASS'
#!/bin/bash
prompt="$1"
if [[ "$prompt" == *"github"* ]]; then
  echo "${GITHUB_TOKEN}"
elif [[ "$prompt" == *"huggingface"* ]]; then
  echo "${HF_TOKEN}"
fi
ASKPASS
chmod +x "$askpass_script"
export GIT_ASKPASS="$askpass_script"
export GIT_TERMINAL_PROMPT=0

git add -A
if git diff --cached --quiet; then
  echo "No file changes to commit (tag/push only if needed)."
else
  git -c commit.gpgsign=false commit -m "$(cat <<EOF
Release v${VERSION}: Golden Green Sporting Club site.

EOF
)"
fi

if git rev-parse "v${VERSION}" >/dev/null 2>&1; then
  echo "Tag v${VERSION} already exists."
else
  git tag -a "v${VERSION}" -m "GoldenGreenFC v${VERSION}"
fi

# Ensure public GitHub repo exists
if ! gh repo view "${GH_USER}/${REPO_NAME}" >/dev/null 2>&1; then
  gh repo create "${GH_USER}/${REPO_NAME}" --public --source=. --remote=origin --description "Golden Green Sporting Club — Dream Big, Do More (Est. 2012)" || true
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://${GH_USER}@github.com/${GH_USER}/${REPO_NAME}.git"
fi

echo "Pushing to GitHub..."
git push -u origin HEAD:main
git push origin "v${VERSION}"

# GitHub release (idempotent-ish)
if ! gh release view "v${VERSION}" >/dev/null 2>&1; then
  gh release create "v${VERSION}" --title "Golden Green SC v${VERSION}" --notes "Public site deployment v${VERSION} for Golden Green Sporting Club."
fi

# Ensure public HF Space exists
hf repo create "${HF_USER}/${REPO_NAME}" --type space --space-sdk static --no-private --exist-ok

echo "Pushing to Hugging Face Space..."
git push -u hf HEAD:main --force

echo "Done."
echo "  GitHub:  https://github.com/${GH_USER}/${REPO_NAME}"
echo "  Release: https://github.com/${GH_USER}/${REPO_NAME}/releases/tag/v${VERSION}"
echo "  HF:      https://huggingface.co/spaces/${HF_USER}/${REPO_NAME}"
echo "  Live:    https://$(echo "${HF_USER}" | tr '[:upper:]' '[:lower:]')-$(echo "${REPO_NAME}" | tr '[:upper:]' '[:lower:]').static.hf.space/"
