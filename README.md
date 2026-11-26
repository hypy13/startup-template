# Startup monorepo template

A minimal Turborepo starter with Next.js, Django, PostgreSQL, Redis, and Celery. It includes a small health check as an example of the frontend component, Zustand store, and service layers.

## Start a project from this template

### Create your own repository on GitHub

1. Open the [startup-template repository](https://github.com/hypy13/startup-template) and choose **Use this template → Create a new repository**.
2. Choose your account or organization, enter a project name, and create the repository. GitHub copies the default branch files into a new repository with its own initial commit. [GitHub's template guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)
3. Clone your **new** repository. Replace `YOUR-ACCOUNT` and `my-project` with your repository details.

   ```sh
   git clone https://github.com/YOUR-ACCOUNT/my-project.git
   cd my-project
   git remote -v
   ```

   The fetch and push URLs for `origin` should both point to your new repository.

If the **Use this template** button is missing, a repository admin can enable **Settings → General → Template repository**. You can also use the clone-and-switch method below. [GitHub's template settings guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)

### Clone directly and switch to your own repository

A direct clone sets `origin` to `hypy13/startup-template`. To use that clone for your project, first create an empty GitHub repository under your account or organization. Leave the README, `.gitignore`, and license options unchecked so the destination has no initial commit.

```sh
git clone https://github.com/hypy13/startup-template.git my-project
cd my-project
git remote set-url origin https://github.com/YOUR-ACCOUNT/my-project.git
git remote -v
```

If you already cloned the template, start at `git remote set-url` from inside that clone. Once both `origin` URLs show your repository, push your current branch and set its upstream.

```sh
git push -u origin HEAD
```

This method carries the template's commit history into your project. [GitHub's remote URL guide](https://docs.github.com/en/get-started/git-basics/managing-remote-repositories)

### Run and customize your project

1. Follow [Development with Docker](#development-with-docker) to create your local `.env`, start the stack, and apply the database migrations. For a setup without Docker, follow [Local development](#local-development).
2. Open `http://localhost:3000` and check that the sample page can reach the Django API. The API also responds directly at `http://localhost:8000/api/health/`.
3. Replace the sample homepage in `apps/web/src/app/page.tsx` and add your Django apps under `apps/api/` alongside `config/`. Add project-specific API routes in `apps/api/config/urls.py` or include URL configurations from your Django apps.
4. If you deploy through GitHub Actions, configure the production environment and secrets in **your new repository**. See [Deploy from GitHub Actions](#deploy-from-github-actions).

## Requirements

Docker and Docker Compose for the container workflow. For local development, use Node.js 22, pnpm 10, Python 3.12 or 3.13, uv, PostgreSQL, and Redis.

## Development with Docker

```sh
cp .env.example .env
docker compose up --build -d
docker compose exec api python manage.py migrate
docker compose exec api python manage.py createsuperuser
```

Open http://localhost:3000 for the frontend, http://localhost:8000/admin/ for Django Daisy, and http://localhost:8000/api/health/ for the API. Changes to application code are mounted into the development containers. View logs with `docker compose logs -f` and stop with `docker compose down`. PostgreSQL data persists in a Docker volume.

## Local development

Start PostgreSQL and Redis locally, copy `.env.example` to `.env`, and export its values in your shell. For example, in bash: `set -a; source .env; set +a`. Then:

```sh
pnpm install
uv sync --project apps/api
cd apps/api
uv run python manage.py migrate
uv run python manage.py runserver
# In a second terminal, with the same environment:
uv run celery -A config worker -l info
# In a third terminal, from the repository root:
pnpm dev
```

The Next.js server proxies `/api/` to `API_INTERNAL_URL`, defaulting to `http://localhost:8000`. The frontend uses relative API URLs, avoiding browser CORS configuration.

## Production

Copy `.env.production.example` to a private file such as `.env.production`, generate a unique Django secret and database password, and set the public host and HTTPS CSRF origin. Then run:

```sh
docker compose --env-file .env.production -f compose.production.yaml up --build -d
docker compose --env-file .env.production -f compose.production.yaml exec api python manage.py createsuperuser
```

The API runs migrations and collects static files at startup. Configure a trusted HTTPS reverse proxy on the host to route `/admin/` and `/static/` to `127.0.0.1:8000`, and other traffic to `127.0.0.1:3000`. The proxy must overwrite `X-Forwarded-Proto` with the actual client scheme; Django trusts that header. Secure cookies require HTTPS. Configure backups, deployment-specific secrets, and monitoring before exposing a real application. The API and web ports are deliberately bound to loopback; PostgreSQL and Redis are internal to Compose.

### Deploy from GitHub Actions

The [Deploy production workflow](.github/workflows/deploy.yml) deploys the selected branch or tag to a Linux server over SSH. It builds the images on the server and checks `/api/health/` through Next.js after starting the stack.

1. Give a deployment account access to Docker and Docker Compose v2 on the server. The server needs `curl` and must accept SSH connections from GitHub-hosted runners on port 22. Add the deployment key's public half to the account's `~/.ssh/authorized_keys`.
2. As that account, create `~/startup-template/.env.production` using `.env.production.example`. Set the production values as described above and make the file readable only by that account. Include `localhost`, `127.0.0.1`, and `api` in `DJANGO_ALLOWED_HOSTS` for internal requests and the workflow health check.
3. In the GitHub repository, create an environment named `production`. Add `DEPLOY_HOST` and `DEPLOY_USER` as environment variables. Add `DEPLOY_SSH_PRIVATE_KEY` (the unencrypted private key) and `DEPLOY_SSH_KNOWN_HOSTS` (a `known_hosts` entry for `DEPLOY_HOST`, verified against the server's host key) as environment secrets. If your GitHub plan lacks environment support for private repositories, remove `environment: production` from the workflow and use repository-level Actions variables and secrets with the same names. [GitHub environment setup](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments)
4. Once the workflow is on the default branch, open **Actions → Deploy production → Run workflow** and select the revision to deploy. On the first deployment, create an admin account from `~/startup-template` using a copy of `compose.production.yaml` and the `createsuperuser` command above.

The workflow uses the fixed Compose project name `startup-template` so successive deployments keep using the same PostgreSQL volume. If you already run this stack on the server, check its project name before switching to the workflow. Set `--project-name` in the workflow to match your existing project if needed.

## Structure and commands

- `apps/web/src/app`: Next.js routes and layout.
- `apps/web/src/components`, `services`, `stores`: UI, API calls, and client state.
- `apps/api/config`: Django configuration, URLs, and Celery app. Add domain apps alongside `config`.
- `pnpm build`, `pnpm lint`, and `pnpm typecheck`: Turborepo frontend tasks.
- `uv run --project apps/api python apps/api/manage.py check`: Django system checks (requires the environment variables above).

Dependency lockfiles are committed for reproducible installs. Run `uv lock --project apps/api` or `pnpm install` when changing dependencies. Keep `.env` files and production secrets out of Git.
