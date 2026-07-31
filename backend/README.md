# Healthify Backend 🌿

REST API for Healthify — AI-powered skincare & cosmetic ingredient analysis.
Node.js 22 · Express 5 · TypeScript (strict) · MongoDB/Mongoose · JWT.
Final Year Software Engineering Project.

## Testing from a phone on the same Wi-Fi

The server binds `0.0.0.0` by default, so it already accepts connections from
other devices on the network — no change needed. On startup it prints a ready-
made `flutter run` command for each network interface, labelled by adapter:

```
Healthify API listening on http://localhost:5000 (bound to 0.0.0.0, development)
To run the Flutter app on a physical device, use your Wi-Fi address below:
  [Wi-Fi] flutter run --dart-define=HEALTHIFY_API_BASE_URL=http://192.168.1.3:5000/api/v1
  [vEthernet (WSL)] ...
```

Pick the `[Wi-Fi]` (or `[Ethernet]`) line — virtual adapters such as WSL,
Docker and VirtualBox are listed last and are unreachable from a phone.

If the phone still cannot connect, the cause is almost always the host
firewall: allow inbound TCP on the port, or on Windows run
`New-NetFirewallRule -DisplayName "Healthify API" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow`
in an elevated shell. Set `HOST=127.0.0.1` to restrict the server to this
machine again.

## Seeded accounts

Ingredients, catalog products and two accounts are seeded automatically on
startup in development. To seed explicitly (or after wiping the database):

```sh
npm run seed
npm run seed -- --force-password   # also reset the seeded passwords
```

| Role | Email | Password |
| --- | --- | --- |
| Admin | `admin@healthify.com` | `Admin12345` |
| Demo user | `thakuri.sumina05@gmail.com` | `User12345` |

The seeder is idempotent: it never duplicates an account and never rewrites a
password that has since been changed (pass `--force-password` for that). An
account that already exists as a normal user is promoted to admin, which is
the recovery path if it was registered through the API first.

Override any of these with `ADMIN_EMAIL` / `ADMIN_PASSWORD` / `DEMO_EMAIL` /
`DEMO_PASSWORD` in `.env`. **These defaults are public demo credentials**, so
the startup seeder deliberately skips in production until both passwords are
overridden; run `npm run seed` once they are.

> Roles live in the JWT. Promoting an account does not upgrade a session that
> is already signed in — log out and back in to get a token carrying the new
> role.

## Getting started

```sh
cp .env.example .env   # fill in secrets (see comments inside)
npm install
npm run dev            # http://localhost:5000
```

- **Swagger/OpenAPI docs**: `http://localhost:5000/api/docs`
- **Health check**: `GET /api/v1/health`
- **MongoDB**: local `mongod` or a MongoDB Atlas URI (cloud database). In
  development the API stays up without a DB; in production a failed
  connection is fatal. On first boot the ingredient database (14 curated
  ingredients) and product catalog (10 products) are seeded automatically.
- **AI**: set `AI_API_KEY` (Anthropic) to run explanations & chat on Claude;
  without it a deterministic, data-grounded fallback keeps everything working.
- **Payments**: set `KHALTI_SECRET_KEY` / `ESEWA_SECRET_KEY` to use the real
  sandbox gateways; without keys checkout runs in clearly-marked simulated
  mode so the premium flow is demonstrable end-to-end.

## API surface (all under /api/v1)

| Area | Endpoints |
| --- | --- |
| Auth | register, login, refresh (rotating), logout, forgot/reset password |
| Users | `GET/PATCH /users/me`, `PUT /users/me/skin-profile` |
| Ingredients | search, daily, recommended (profile-aware), detail |
| Analysis | `POST /analysis` (full pipeline), history, detail, compare, favorite |
| Products | catalog search with category filter + pagination |
| Chat | `POST /chat` — AI assistant, optionally grounded in an analysis |
| Favorites | list / add / remove ingredient favorites |
| Notifications | list, mark read, mark all read |
| Dashboard | single-round-trip home aggregate |
| Premium | plans, checkout (Khalti/eSewa), verify, payment history |
| Admin | platform stats/analytics, ingredient & product CRUD (role-gated) |

**Response contract**: `{ success, message, data, meta? }` on success,
`{ success: false, message, errors? }` on failure (422 with per-field
errors for validation).

## Architecture

Modular monolith: each feature is a self-contained module with a
**routes → controller → service → repository → model** chain.

```
src/
├── server.ts / app.ts        # Entrypoint & Express composition
├── config/                   # Zod-validated env, winston logger, db, swagger
├── middlewares/              # errors, zod validation, JWT auth, uploads
├── modules/
│   ├── auth/                 # JWT + rotating refresh tokens (hashed, TTL)
│   ├── users/                # profile + skin profile
│   ├── ingredients/          # seeded DB + recommendation engine v1
│   ├── analysis/             # matching + explainable scoring engine
│   ├── ai/                   # Claude integration with grounded fallback
│   ├── products/             # catalog powering alternatives & search
│   ├── chat/                 # assistant endpoint
│   ├── premium/              # plans + Khalti/eSewa payment orchestration
│   ├── admin/                # analytics + catalog CRUD
│   ├── favorites/ notifications/ dashboard/ health/
├── utils/                    # ApiError, response envelope, JWT helpers
└── types/                    # Express request augmentation
tests/                        # Vitest + Supertest
```

**Security**: helmet, CORS, tiered rate limiting (stricter on credential
endpoints), bcrypt password hashing, refresh tokens stored as SHA-256
hashes with TTL + rotation + replay-detection (family revocation), reset
codes hashed with 15-minute expiry, JWT type enforcement (a refresh token
can never act as an access token), account-existence non-disclosure on
forgot-password, Zod validation on every write route.

**Scoring engine** (`modules/analysis/scoring.service.ts`): deterministic
and explainable — every point moved is captured as a per-ingredient reason
(safety rating, skin-type fit, concern targeting, declared allergens,
irritation cautions), which also grounds the AI explanation.

## Scripts & testing

| Script | Purpose |
| --- | --- |
| `npm run dev` | Watch-mode dev server (tsx) |
| `npm run build` / `npm start` | Compile (strict tsc) and run `dist/` |
| `npm test` | Vitest: unit (scoring, JWT) + E2E API suites |
| `npm run typecheck` | Type-check without emitting |

E2E suites run against a real MongoDB (`healthify_test` database, dropped
before/after) and **auto-skip when MongoDB is unreachable**, so the unit
suite passes anywhere. Suites cover: full auth flow with refresh-token
replay detection, the complete analysis pipeline (allergy/irritation
detection, alternatives, dashboard auto-update, compare, chat), premium
checkout & activation, product search, and admin authorization + CRUD.
