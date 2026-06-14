---
name: pr
description: Create well-documented pull requests with comprehensive descriptions via GitHub CLI. Use when user asks to create a PR, open a pull request, run /pr, or publish their branch for review.
---

# Pull Request

## Quick start

```
/pr
```

Analyzes commits since branching from the default branch, drafts a title and description, and creates the PR via `gh pr create`.

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- On a feature branch (not `main` or `master`)
- Changes committed locally

## Workflow

### 1. Gather branch context

Run these in parallel:

```bash
git status
git diff
git branch -vv
git log --oneline -10
git diff main...HEAD
```

Use the repo's default branch if not `main` (check `master` or `gh repo view --json defaultBranchRef`).

### 2. Analyze changes

Review **all** commits that will be in the PR — not just the latest:

- What problem does this solve?
- What files or modules changed and why?
- Any breaking changes, migrations, or env updates?
- UI changes that need screenshots?

### 3. Draft the PR

**Title**: Imperative and concise (e.g. "Add retry logic to webhook handler").

**Body**: Use the template below. Fill every section with specifics from the diff — no generic placeholders. Omit Screenshots if there are no UI changes.

### 4. Push and create

```bash
git push -u origin HEAD   # only if branch is not on remote

gh pr create --title "TITLE" --body "$(cat <<'EOF'
## Summary
...

EOF
)"
```

Return the PR URL to the user.

## PR body template

```markdown
## Summary
Brief description of changes

## Changes
- List of specific changes made

## Testing
How to test these changes

## Screenshots
(if applicable)

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No breaking changes
```

## Guardrails

- Never force-push to `main` or `master`
- Do not commit unless the user explicitly asks
- Warn before committing files that may contain secrets (`.env`, credentials, etc.)
- Do not push unless the user explicitly asks (except when required to create the PR)
