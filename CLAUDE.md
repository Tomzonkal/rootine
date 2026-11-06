# CLAUDE.md — instrukcje dla agentów (i ludzi)

Rootine to self-hosted „GRM: Garden Relationship Manager”: baza roślin z regułami pielęgnacji →
rabaty z nasadzeniami → automatycznie wyliczana lista zadań i kalendarz.

## Struktura repo

| Ścieżka | Zawartość |
|---|---|
| `backend/` | FastAPI (uv): `app/api/v1`, `app/core`, `app/models`, `app/schemas`, `app/services`, `app/storage`, `alembic/`, `tests/` |
| `frontend/` | pnpm workspace: `apps/web` (React + Vite), `packages/api-client` (typy z OpenAPI + hooki TanStack Query) |
| `data/plants/` | seed katalogu roślin (YAML, 1 plik = 1 gatunek) |
| `scripts/` | skrypty pomocnicze (`link-meta.sh`, `check-meta-run.sh`, testy w `scripts/tests/`) |
| `.ai/` | konfiguracja Cezara: workflow i skille agentów |
| `meta/` | **lokalna, niepubliczna** baza wiedzy (gitignorowana) — może nie istnieć |

Katalogi `backend/`, `frontend/`, `data/` powstają w kolejnych issues — jeśli ich nie ma, to normalne.

## Komendy

- `make check` — wszystko, co sprawdza CI. **Musi przechodzić przed otwarciem PR.**
- `make help` — lista celów.

## Zasady (obowiązują każde zadanie)

- API pod `/api/v1`; backend nie renderuje HTML.
- Zasoby użytkownika filtrowane po `owner_id`; obcy zasób → **404** (nie 403).
- Daty zadań to `date`; „dziś” liczone w strefie użytkownika (domyślnie `Europe/Warsaw`).
- Teksty UI tylko przez i18next (`pl.json`) — żadnych tekstów na sztywno w komponentach.
- Komponenty UI nie wołają `fetch` — tylko hooki z `@rootine/api-client`.
- Wygenerowanego klienta API (`schema.d.ts`, `openapi.json`) nie edytuje się ręcznie — regeneruj.
- Zależności tylko o licencjach zgodnych z AGPL-3.0 (MIT/BSD/Apache-2.0/ISC/LGPL).
- Testy backendu używają osobnej bazy na przebieg — nie zakładaj wspólnej bazy testowej.

## Workflow

1. Jedno issue = jedno zadanie. Trzymaj się sekcji „Zakres” i „Poza zakresem”;
   dostrzeżone problemy zgłoś jako nowe issue (`gh issue create`), nie naprawiaj przy okazji.
2. Bierz issue tylko, gdy wszystkie „Depends on #N” są zamknięte.
3. TDD: najpierw test, który nie przechodzi, potem kod, potem refaktor.
4. `make check` zielone → PR z `Closes #<nr>` wg szablonu.
5. Issue z etykietą `needs-human-review` merguje człowiek; pozostałe — merge po zielonym CI.
6. Po 2 nieudanych podejściach do tego samego problemu: przerwij, opisz w komentarzu do issue,
   co próbowałeś i gdzie utknąłeś, dodaj etykietę `blocked`.

## Baza wiedzy `meta/` (jeśli istnieje)

`meta/` jest lokalny i nie trafia do repo (w worktree Cezara to symlink z `scripts/link-meta.sh`).

- **Przed pracą:** przeczytaj `meta/README.md` (indeks), wpisy z `meta/assumptions/` i `meta/lessons/`
  dotyczące Twojego obszaru oraz 3 ostatnie pliki z `meta/runs/`. Specyfikacje: `meta/spec/`.
- **Po pracy:** zapisz `meta/runs/YYYY-MM-DD-issue-<nr>-<slug>.md` wg `meta/_templates/run.md`;
  nowa decyzja → `meta/assumptions/NNNN-slug.md`, nieoczywista lekcja → `meta/lessons/NNNN-slug.md`
  (kolejny wolny numer) + jedna linia dopisana do `meta/README.md`.
- `meta/` ma własne lokalne repo git: `git -C meta add <tylko swoje pliki> && git -C meta commit`.
- Nie wklejaj treści `meta/` do PR-ów ani commitów w repo projektu.
