---
name: pytest-django-testing
description: Write or debug Python tests with pytest, including Django models, views, API permissions, database behavior, and Celery tasks with pytest-django.
---

# pytest and Django testing

- Locate the test runner, Django settings, test database, fixtures, and CI commands. Follow the repo's existing test layout and fixture style. For Django projects using its built-in runner, preserve that setup unless adopting pytest is part of the task.
- Use the normal boundary for the behavior under test. Test pure functions directly, request behavior through the Django or DRF test client, and persisted behavior against the test database. Assert status, response shape, and relevant persisted state or side effects.
- Request database access explicitly with pytest-django. Use transaction-capable tests when real commit or rollback behavior is the point. For code scheduled with on_commit, use the existing commit-callback fixture or exercise real commits as appropriate.
- Test task logic and task scheduling separately where useful. Patch external services or task publication at the boundary, and use a test worker when delivery or execution semantics are part of the contract.
- Run the smallest relevant test set first and broaden it when shared behavior changes. Use PostgreSQL for tests whose correctness depends on PostgreSQL-specific types, constraints, or locking.

[pytest-django database access](https://pytest-django.readthedocs.io/en/latest/database.html)
