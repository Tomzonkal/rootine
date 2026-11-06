# Rootine

**GRM — Garden Relationship Manager.** A self-hosted care planner for small gardens.

Rootine ships with a plant database where every species carries care rules: when to prune,
how often to fertilize, when to water. You describe your garden as beds and the plants growing
in them. Rootine turns that into a to-do list and a calendar, so you never have to set up
reminders yourself. You get one view across the whole garden and one per bed.

Everyone runs their own instance (Docker Compose). One instance can host several accounts, and
each account has its own garden. The web app is the MVP. A mobile app comes later and will reuse
the same API client.

> **Status:** under construction (pre-v0.1). Progress is tracked in
> [milestones](https://github.com/Tomzonkal/rootine/milestones) and
> [issues](https://github.com/Tomzonkal/rootine/issues).

## Stack

- **Backend:** Python 3.12, FastAPI, SQLAlchemy 2, Alembic, PostgreSQL 16. It is a REST API only.
- **Frontend:** React, TypeScript and Vite in a pnpm workspace. The shared `@rootine/api-client`
  package is also meant for the future mobile app.

## Development

See [CLAUDE.md](CLAUDE.md) for the repository layout, commands and conventions. These apply to
humans and AI agents alike. Run every check with:

```bash
make check
```

## License

[GNU AGPL-3.0](LICENSE). You may use Rootine commercially. If you distribute a modified version,
or offer one as a network service, you must publish its source code.
