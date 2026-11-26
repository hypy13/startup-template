---
name: update-startup-template
description: Bring later improvements from hypy13/startup-template into a project based on that template. Use when asked to sync or update a derived project, including requests written as /update-startup-template.
---

# Update Startup Template

Run [scripts/update.sh](scripts/update.sh) with Bash from the derived repository, starting on the branch that should receive the update. The helper fetches the upstream default branch and prepares a local review branch. It figures out the previous template version from `.startup-template-version`, shared ancestry, or an exact match with the project's initial snapshot.

- For a check-only request or a request about what would change, pass `--check`. This fetches template history and reports the template commit range and file summary without switching branches or applying the patch.
- If the helper cannot identify a unique baseline, ask for the full SHA of the last upstream version incorporated into the project. Use `--base SHA` for that first update only. For a shallow derived repository, obtain the missing project history before inferring a baseline.
- On success, inspect the staged diff and run the project's relevant checks. When they pass, commit the staged update locally. Keep `.startup-template-version` in that commit so the next update starts from the right version even if this branch is squash-merged. If checks fail, leave the changes available for review and report the failure.
- On failure during application, inspect `git status` and `git ls-files -u`. Resolve conflicts only when both sides' intent is clear. Preserve project-specific edits and verify every upstream change against the reported commit range before recording the target SHA. If product behavior needs a decision, leave the branch for review and report the affected files. Leave the version marker at its old value until the entire update is accounted for.
- Report the branch, template range, changes, and checks. If the template is current, report that result without creating a branch. Pushing or merging the review branch requires a separate user request.
