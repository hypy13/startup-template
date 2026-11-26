#!/usr/bin/env bash
set -euo pipefail

template_url=https://github.com/hypy13/startup-template.git
template_ref=refs/startup-template/latest
version_file=.startup-template-version
requested_base=
check_only=false

fail() {
  printf '%s\n' "$*" >&2
  exit 1
}

while (($# > 0)); do
  case "$1" in
    --check) check_only=true; shift ;;
    --base)
      [[ $# -ge 2 && $2 =~ ^[0-9a-f]{40}$ ]] || fail 'Pass a full template commit SHA to --base.'
      requested_base=$2
      shift 2
      ;;
    *) fail 'Usage: bash update.sh [--check] [--base TEMPLATE_COMMIT_SHA]' ;;
  esac
done

repo_root=$(git rev-parse --show-toplevel) || fail 'Run this from a derived project Git repository.'
cd "$repo_root"

for remote_url in "$(git remote get-url origin 2>/dev/null || true)" \
  "$(git remote get-url --push origin 2>/dev/null || true)"; do
  case "${remote_url%.git}" in
    */github.com/hypy13/startup-template|github.com:hypy13/startup-template|*@github.com:hypy13/startup-template)
      fail 'Run this from your derived project with its own origin.'
      ;;
  esac
done

git rev-parse --verify HEAD >/dev/null || fail 'The project needs an initial commit.'
if [[ $check_only == false ]]; then
  git symbolic-ref --quiet HEAD >/dev/null || fail 'Switch to the project branch you want to update.'
  worktree_status=$(git status --porcelain --untracked-files=all)
  [[ -z $worktree_status ]] || fail 'Start the update with a clean working tree.'
  for operation in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD rebase-merge rebase-apply sequencer; do
    [[ ! -e $(git rev-parse --git-path "$operation") ]] || fail 'Finish the current Git operation first.'
  done
fi

git fetch --no-tags --no-recurse-submodules --no-write-fetch-head "$template_url" "+HEAD:$template_ref"
target=$(git rev-parse --verify "$template_ref^{commit}")
if git cat-file -e "$target:$version_file" 2>/dev/null; then
  fail "The upstream template uses the reserved path $version_file."
fi

if git cat-file -e "HEAD:$version_file" 2>/dev/null; then
  [[ -z $requested_base ]] || fail "Use the recorded baseline in $version_file."
  [[ -f $version_file && ! -L $version_file ]] || fail "Expected a regular file at $version_file."
  base=$(git show "HEAD:$version_file")
elif [[ -e $version_file || -L $version_file ]]; then
  fail "The path $version_file exists outside the project history."
elif [[ -n $requested_base ]]; then
  base=$requested_base
else
  [[ $(git rev-parse --is-shallow-repository) == false ]] || fail 'Obtain the full project history or pass --base.'
  if ! base=$(git merge-base --all HEAD "$target"); then
    project_root=$(git rev-list --max-parents=0 HEAD)
    [[ $project_root =~ ^[0-9a-f]{40}$ ]] || fail 'The project has multiple roots. Pass --base.'
    root_tree=$(git rev-parse "$project_root^{tree}")
    base=$(git log --format='%H %T' "$target" | awk -v tree="$root_tree" '$2 == tree { print $1 }')
  fi
  [[ $base =~ ^[0-9a-f]{40}$ ]] || fail 'Could not identify one template baseline. Pass --base.'
fi

[[ $base =~ ^[0-9a-f]{40}$ ]] || fail 'The recorded template baseline is invalid.'
git merge-base --is-ancestor "$base" "$target" || fail 'The baseline is outside the fetched template history.'
if [[ $base == "$target" ]]; then
  printf 'Already on template version %s.\n' "$target"
  exit 0
fi

printf 'Template update %s → %s\n' "$base" "$target"
git diff --stat --no-ext-diff "$base" "$target"
if [[ $check_only == true ]]; then
  exit 0
fi

branch="sync-startup-template-${target:0:12}"
git switch -c "$branch"
if ! git diff --quiet --no-ext-diff "$base" "$target"; then
  if ! git diff --binary --full-index --find-renames --no-ext-diff --no-textconv \
    --src-prefix=a/ --dst-prefix=b/ "$base" "$target" | git apply --3way --index; then
    fail "Patch needs review on $branch. The version marker was not advanced. Inspect git status before continuing."
  fi
fi

printf '%s\n' "$target" > "$version_file"
git add --force -- "$version_file"
printf 'Staged template update on %s. Review and test the staged changes before committing.\n' "$branch"
