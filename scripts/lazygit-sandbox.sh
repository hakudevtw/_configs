#!/usr/bin/env bash
# Create a throwaway git repo for practising lazygit: diverging branches, messy wip commits to
# squash, a hotfix commit to cherry-pick, and a rebase that conflicts.
#
# Usage: ./scripts/lazygit-sandbox.sh [dir]     (default: ~/lazygit-sandbox, recreated each run)

set -euo pipefail

DIR="${1:-$HOME/lazygit-sandbox}"
rm -rf "$DIR"
mkdir -p "$DIR"
cd "$DIR"

git init -q -b main
git config user.name "Practice"
git config user.email "practice@example.com"
git config core.pager cat

c() { git add -A && git commit -q -m "$1"; }

printf '# Demo app\n\nTitle: Hello\nStatus: draft\n' > README.md; c "chore: init demo app"
printf 'welcome page\n' > home.txt; c "feat: add home page"
printf 'footer v1\n' > footer.txt; c "feat: add footer"

git switch -q -c hotfix
printf 'null check added\n' > fix.txt; c "fix: add null check"
git switch -q main

git switch -q -c feature/login
printf 'login form\n' > login.txt; c "wip: add login form"
printf 'login form (typo fixed)\n' > login.txt; c "wip: fix typo"
printf 'login form (typo fixed)\nvalidation\n' > login.txt; c "wip: add validation"
sed -i '' 's/^Title: Hello/Title: Hello from the login branch/' README.md; c "feat: login page title"
git switch -q main

# main edits the same README line, so rebasing feature/login onto main conflicts
sed -i '' 's/^Title: Hello/Title: Hello from main/' README.md; c "docs: update title on main"
printf 'footer v2\n' > footer.txt; c "feat: footer v2"
git switch -q feature/login

echo "Practice repo ready: $DIR"
echo "  cd $DIR && lazygit"
