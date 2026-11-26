---
name: postgresql-migrations
description: Plan, implement, or review PostgreSQL schema migrations and data backfills, especially changes to populated tables, constraints, indexes, locks, and rollout order.
---

# PostgreSQL migrations

- Check the PostgreSQL version, migration tool, existing dependencies, expected data volume, and rollout order. Review the SQL the tool produces. Classify changes by lock duration, scans, rewrites, and compatibility with concurrently running application versions.
- For changes that cannot fit the maintenance window, plan an expand and contract sequence. Introduce schema compatible with both app versions, backfill in resumable batches, verify completeness, then enforce constraints or remove old schema after dependent code has moved.
- For large tables, evaluate concurrent index creation and deferred constraint validation where PostgreSQL supports them. Verify transaction restrictions, lock behavior, and retry cleanup for the specific statement and version. Explicitly account for duplicate or null legacy values when introducing constraints.
- In Django data migrations, use historical models and the migration's connection alias. Keep backfill ordering and retry behavior explicit. When schema changes use raw SQL, keep the migration tool's model state in sync.
- Verify against a disposable PostgreSQL database with representative existing rows. Explain deployment order, validation, and what recovery can restore if a change is irreversible.

[PostgreSQL ALTER TABLE reference](https://www.postgresql.org/docs/current/sql-altertable.html)
