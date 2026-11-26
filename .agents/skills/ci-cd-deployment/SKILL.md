---
name: ci-cd-deployment
description: Build or debug repository CI and deployment workflows, including GitHub Actions, Docker image builds, Compose releases, and post-deployment health checks.
---

# CI/CD and deployment

- Read existing workflows, lockfiles, build scripts, and deployment docs. Use the repo's normal test and build entry points. Identify the trigger, source revision, target environment, and artifact or image that reaches production.
- For GitHub Actions, scope token permissions to the job and pass untrusted event values to scripts through quoted environment variables. Keep deploy credentials in the appropriate secret store. Test pull requests without exposing deployment credentials to untrusted code.
- Trace deploy steps in order. Confirm how migrations, health checks, persistent data, and retries behave. For Compose updates, preserve the existing project and volume identity unless the change explicitly migrates data. Identify the revision or image a rollback would restore and whether migrations remain compatible.
- Validate YAML and shell syntax, expand Compose configuration with non-sensitive test values, and use a dry run or simulated failure path where supported. Check the changed app through its normal ingress when authorized to deploy. Report which checks ran and whether the live target was exercised.

[GitHub Actions workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax) and [Docker Compose CLI reference](https://docs.docker.com/reference/cli/docker/compose/)
