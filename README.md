# PAIASA DEV Team

Razvojni tim agenata za Claude Code. Prima promptove (iz [PAIASA PM Team](https://github.com/harymedire/paiasa-pm) ili ručno napisane) i implementira ih **do kraja**:
- trijaža rizika i testovi iz kriterija prihvatanja;
- nezavisni code, sigurnosni, arhitektonski i performance pregledi;
- provjera UI-ja u browseru i paket dokaza;
- draft PR, staging, priprema za produkciju i održavanje.

Claude Code koji pokreneš je **Orkestrator**. On vodi tim i, ako PM tim to preporuči, dodaje nove agente i prilagođava modele za projekat.

## Instalacija

Potreban je [Claude Code](https://claude.com/claude-code), a preporučeno je imati i [GitHub CLI](https://cli.github.com) (`gh`) za PR-ove. U terminalu:

```bash
claude plugin marketplace add harymedire/paiasa-dev
```

```bash
claude plugin install paiasa-dev@paiasa-dev
```

Ili unutar Claude Codea: `/plugin marketplace add harymedire/paiasa-dev`, pa `/plugin install paiasa-dev@paiasa-dev`.

**Ažuriranje:**

```bash
claude plugin marketplace update paiasa-dev
```

```bash
claude plugin update paiasa-dev@paiasa-dev
```

U otvorenoj sesiji nakon ažuriranja pokreni `/reload-plugins`.

## Korištenje

Otvori Claude Code u **repozitoriju koda** i pokreni:

```
/paiasa-dev:dev-team ../moj-projekat/.product/handoff          ← prvi put: cijeli handoff (čita i team.md)
/paiasa-dev:dev-team ../moj-projekat/.product/handoff/prompts/03-booking-calendar.md
/paiasa-dev:dev-team <zalijepljen opis zadatka>
/paiasa-dev:dev-team resume
/paiasa-dev:dev-team release
/paiasa-dev:dev-team maintain
```

- **Novi projekat:** postavi osnovu (testovi, linter, CLAUDE.md), predloži CI i sigurnosne skenere, pa implementira.
- **Postojeći projekat koji je neko započeo:** prvo uradi pregled koda, sigurnosti i arhitekture i daje ti izvještaj o stanju s prijedlozima. Bez tvog odobrenja ništa ne refaktoriše.
- **Nastavak:** ako postoji `.dev/STATE.md`, nastavlja gdje je stao.

## Tok jednog zadatka

```
Prompt → Codebase Analyst (mapa koda) → trijaža rizika (procjena + fiksna pravila)
  → Definition of Ready (nejasno? → pitanja za PM tim, zadatak čeka)
  → [novina → spike s 2–3 prototipa] [arhitektura → ADR, veće promjene odobrava čovjek]
  → Test Engineer: testovi iz kriterija prihvatanja (moraju prvo pasti)
  → Implementer: kod dok testovi ne prođu (Fable za rizične zadatke)
  → svježi, nezavisni pregledi: Code Reviewer + Risk Guardian (uvijek)
       + Security / Architecture / Performance prema oznakama rizika
  → gate: 0 otvorenih kritičnih/značajnih nalaza (najviše 3 kruga, pa eskalacija čovjeku)
  → UI Verifier: browser, mobilna i desktop širina, snimci ekrana
  → Evidence Reporter: paket dokaza → draft PR
  → ČOVJEK: review i merge  → staging → ČOVJEK: odobrenje produkcije
```

## Granice (ugrađene)

- **Merge u glavnu granu i produkciju rade samo ljudi**, ili agent nakon izričitog "da" za tačno to izdanje.
- **Nema pristupa produkcijskim podacima ni tajnim ključevima.**
- **Ne nagađa ponašanje.** Nejasan zahtjev se vraća PM timu.
- **Ne isključuje testove, skenere ni provjere** da bi nešto prošlo.
- **Guard hook** (aktivan samo u projektima koji imaju `.dev/` folder) blokira force-push, push direktno na main/master, `git reset --hard` na udaljenu granu i commit `.env` fajlova.

## Agenti i modeli

| Agent | Model | Uloga |
|---|---|---|
| Architecture Guardian | Fable | ADR-ovi, arhitektonska pravila, mjesečni pregled trenda |
| Security Reviewer | Fable | prijetnje, OWASP provjera, skeneri, audit |
| Implementer | Opus (Fable za rizične) | implementacija |
| Test Engineer | Opus | testovi iz kriterija prihvatanja, prije koda |
| Code Reviewer | Opus | ispravnost, testovi, konzistentnost |
| Risk Guardian | Opus | na svakom zadatku traži propuštene rizike |
| Performance Engineer | Opus | budžeti, upiti, testovi opterećenja |
| Release Engineer | Opus | CI/CD, staging, release, runbookovi, održavanje |
| Researcher | Opus | spike za nove probleme |
| Codebase Analyst | Sonnet | mapa koda, audit |
| UI Verifier | Sonnet | provjera u browseru |
| Evidence Reporter | Sonnet | paket dokaza |

Modeli se biraju po nivoima: **top → `fable`**, **strong → `opus`**, **fast → `sonnet`**. Preporuke iz PM-ovog `team.md` se primjenjuju po zadatku. Dodatni specijalisti (npr. `payments-specialist`) nastaju u repozitoriju u `.claude/agents/`, pa ih dobija i ljudski tim.

## Šta nastaje u repozitoriju

```
CLAUDE.md                  ← pravila projekta (dijele ga ljudi i agenti)
docs/adr/                  ← arhitektonske odluke
.claude/agents/            ← specijalisti za ovaj projekat (ako trebaju)
.dev/
├── STATE.md               ← status zadataka, šta čeka ljude, sljedeći korak
├── team.md, risk-rules.md ← iz PM preporuke
├── tasks/<id>/            ← prompt, mapa, trijaža, pregledi, odgovori, spike, prijetnje
├── evidence/              ← paketi dokaza → za PM prihvatanje
├── audit/                 ← pregled postojećeg projekta
├── releases/, runbooks/   ← izdanja i operativne upute
└── maintenance/           ← izvještaji održavanja
```

## Povratak PM timu

Paket dokaza iz `.dev/evidence/` daš PM timu: `/paiasa-pm:pm-team accept <putanja>`. PO agent provjerava svaki kriterij prihvatanja na osnovu samih dokaza, a ne na osnovu tvrdnje da je "urađeno".

## Napomene

- Guard hook koristi `bash`. Na Windowsu to zahtijeva Git for Windows, koji Claude Code ionako koristi.
- Prva verzija (0.1.0). Kod izmjena povećaj `version` u `.claude-plugin/plugin.json`.

## English quick start

```bash
claude plugin marketplace add harymedire/paiasa-dev
```

```bash
claude plugin install paiasa-dev@paiasa-dev
```

Then, in your code repository, run `/paiasa-dev:dev-team <prompt file | handoff folder | pasted task | resume | release | maintain>`.

## License

MIT
