# PAIASA DEV Team

Razvojni tim agenata za Claude Code. Prima promptove (iz [PAIASA PM](https://github.com/harymedire/paiasa-pm), iz PAIASA Validate ili ručno napisane) i implementira ih **do kraja**:
- trijaža rizika i testovi iz kriterija prihvatanja;
- nezavisni code, sigurnosni, arhitektonski i performance pregledi;
- provjera UI-ja u browseru i paket dokaza;
- draft PR, staging, priprema za produkciju i održavanje.

Claude Code koji pokreneš je **Orkestrator**. On vodi tim i, ako preporuka tima (`team.md` iz PAIASA Validate) to traži, dodaje nove agente i prilagođava modele za projekat.

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
/paiasa-dev:dev-team ../moj-projekat/plan/prompts               ← promptovi iz PAIASA PM (cijeli folder)
/paiasa-dev:dev-team ../moj-projekat/plan/prompts/03-booking-calendar.md
/paiasa-dev:dev-team ../moj-projekat/.product/handoff            ← handoff iz PAIASA Validate (čita i team.md)
/paiasa-dev:dev-team <zalijepljen opis zadatka>
/paiasa-dev:dev-team resume
/paiasa-dev:dev-team release
/paiasa-dev:dev-team maintain
/paiasa-dev:dev-team harden auth                                 ← puni pregled modula prije produkcije (ili `all`)
/paiasa-dev:dev-team ../plan/prompts/04-login.md --profile prototype   ← profil samo za ovaj zadatak
```

- **Novi projekat:** postavi osnovu (testovi, linter, CLAUDE.md), predloži CI i sigurnosne skenere, pa implementira.
- **Postojeći projekat koji je neko započeo:** prvo uradi pregled koda, sigurnosti i arhitekture i daje ti izvještaj o stanju s prijedlozima. Bez tvog odobrenja ništa ne refaktoriše.
- **Nastavak:** ako postoji `.dev/STATE.md`, nastavlja gdje je stao.

## Profili procesa

Tim radi **razvoj i provjeru onoga što je napravio**, a strogoća zavisi od profila. Profil biraš jednom za projekat (tim pita na početku, a zadani je **standard**) ili za jedan zadatak s `--profile`.

| | prototype | standard (zadano) | production |
|---|---|---|---|
| Kad | demo, izmišljeni podaci | normalan razvoj prije produkcije | pred puštanje, stvarni korisnici |
| Testovi | po jedan za svaki kriterij + negativni testovi pristupa | to + rubni slučajevi iz kriterija | testovi prije koda (Test Engineer) |
| Pregledi | 1 (Code Reviewer) | Code + Risk, Security na prijavi/plaćanju/podacima | svi prema oznakama rizika |
| Runde | 1 | 2 | 2 + ciljana ispravka |
| Dokaz | u opisu PR-a | kratak `evidence.md` | puni paket |
| Istraživanje, ADR | samo kad ti tražiš / nova biblioteka | samo kad ti tražiš / značajne odluke | po oznakama |

Budžet testova je smjernica: S ~10, M ~25, L ~50. Bez izričitog kriterija nema egzotičnih testova, npr. identičnost bajtova slika, determinizam između Windowsa i Linuxa ili matrice svih kombinacija.

Sve što profil odgodi ide u `.dev/followups.md`. Ono što mora biti urađeno prije produkcije dobija oznaku `hardening`. **Release ne prolazi** dok `/paiasa-dev:dev-team harden <modul|all>` to ne zatvori: puni production pregled tih modula, uz preporuku za pen-test gdje ima prijave, plaćanja ili ličnih podataka.

## Tok jednog zadatka (standard)

```
Prompt → trijaža rizika (profil, veličina, ko pregleda)
  → Implementer (opus): kod + testovi za kriterije, u okviru budžeta
  → Implementer sam provjeri: build, testovi, pokrene aplikaciju, prođe glavni tok, ugasi server
  → svježi pregled drugog agenta: Code Reviewer + Risk Guardian (+ Security/Architecture po potrebi)
  → samo "blocking" nalazi (najviše 5 po recenzentu) traže ispravku; ostalo u followups
  → najviše 2 runde; mala ciljana ispravka bez pitanja
  → draft PR → ti dobiješ jedan red: zadatak, link, ADR za potvrdu
  → ČOVJEK: review i merge → staging → ČOVJEK: odobrenje produkcije
```

## Kontinuiran rad

- **Datumi u planu su rokovi, ne termini javljanja.** Tim ne čeka "ponedjeljak", nego radi dok ima spremnih zadataka.
- Dok je jedan zadatak u pregledu, sljedeći već kreće. Paralelne grupe iz README-a promptova kreću zajedno.
- **Naslagani PR-ovi:** zavisni zadatak se grana od grane prethodnog i ne čeka merge. Ti merge-aš jedan po jedan, od najnižeg, s **"Create a merge commit"** (ne squash).
- Nakon prva 2 zadatka tim javlja prosječno vrijeme po zadatku i procjenu do kraja.
- Može predložiti spajanje 2–3 mala povezana prompta u jedan PR.
- **Zaštita od zastoja:**
  - build i unit testovi imaju timeout od 10 min, e2e od 20 min;
  - server pokrenut za provjeru gasi se u istom koraku;
  - watchdog provjerava agente ako se 30 min nijedan fajl ne promijeni;
  - ako ne može ugasiti proces, javi ti tačan PID i komandu.
- **Poruke iz druge sesije (npr. PM):** tim ih ne izvršava sam. Sažme ih u 2–3 reda i traži od tebe jednu riječ, "potvrđujem".

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
| Implementer | Opus (Fable samo u production, uz tvoje "da") | implementacija i provjera urađenog |
| Test Engineer | Opus | production: testovi iz kriterija prije koda |
| Code Reviewer | Opus | ispravnost, testovi, konzistentnost |
| Risk Guardian | Opus | standard i production: traži propuštene rizike |
| Performance Engineer | Opus | budžeti, upiti, testovi opterećenja |
| Release Engineer | Opus | CI/CD, staging, release, runbookovi, održavanje |
| Researcher | Opus | samo kad ti tražiš: spike za nove probleme |
| Codebase Analyst | Sonnet | production (veći zadaci) i preuzimanje projekta |
| UI Verifier | Sonnet | production: provjera u browseru |
| Evidence Reporter | Sonnet | production: puni paket dokaza |

Modeli se biraju po nivoima: **top → `fable`**, **strong → `opus`**, **fast → `sonnet`**. Preporuke iz `team.md` (PAIASA Validate) se primjenjuju po zadatku; bez njega se koristi zadani tim. Dodatni specijalisti (npr. `payments-specialist`) nastaju u repozitoriju u `.claude/agents/`, pa ih dobija i ljudski tim.

### Tvoje izmjene modela i rundi

Možeš u bilo kom trenutku reći timu koje modele da koristi po zadatku ili po agentu i koliko rundi recenzije dozvoljavaš, npr. za demo fazu na sintetičkim podacima. Primjer:

> Za P-03, P-05, P-10 i P-11 implementer i security-reviewer na fable; sve ostalo na opus; najviše 2 runde, pa eskalacija meni.

- Tim to upisuje u `.dev/team.md` i potvrđuje jednom rečenicom. Izmjena važi **od sljedećeg zadatka**, a tekući zadatak ne prekida.
- Tvoja izmjena ima prednost nad `team.md` iz PM-a i nad zadanim pravilima.
- Code-reviewer i risk-guardian rade na svakom zadatku. Zadatak sa security oznakom uvijek dobija security pregled; mijenja se samo model i broj rundi.
- Ako izmjena **oslabi** recenzije, tim upisuje blokirajući korak prije produkcije u `.dev/risk-rules.md`: puni pregled zahvaćenih modula mora proći prije produkcije. Release ne ide dok taj korak nije zatvoren dokazom.

## Šta nastaje u repozitoriju

```
CLAUDE.md                  ← pravila projekta (dijele ga ljudi i agenti)
docs/adr/                  ← arhitektonske odluke
.claude/agents/            ← specijalisti za ovaj projekat (ako trebaju)
.dev/
├── STATE.md               ← status zadataka, šta čeka ljude, sljedeći korak
├── team.md, risk-rules.md ← iz preporuke tima (PAIASA Validate), ako postoji
├── tasks/<id>/            ← prompt, mapa, trijaža, pregledi, odgovori, spike, prijetnje
├── evidence/              ← paketi dokaza → za PM prihvatanje
├── audit/                 ← pregled postojećeg projekta
├── releases/, runbooks/   ← izdanja i operativne upute
└── maintenance/           ← izvještaji održavanja
```

## Povratak PM-u

Paket dokaza iz `.dev/evidence/` daš PM-u: `/paiasa-pm:pm-team accept <putanja>`. PM provjerava svaki kriterij prihvatanja na osnovu samih dokaza, a ne na osnovu tvrdnje da je "urađeno".

## Windows napomene

- Windows Server nema Docker ni WSL: koristi nativni PostgreSQL i Mailpit za lokalni email. Windows 11 Home nema Hyper-V; Docker Desktop traži WSL2.
- Upaljen Node/Next server zaključava fajlove: tim zato gasi servere prije `next build`. Ako `npm ci` padne s EPERM, uzrok je proces koji drži fajl.
- Skripte u projektu trebaju raditi i u PowerShellu (`cross-env`, `rimraf` ili Node skripte, ne bash-only sintaksa).

## Napomene

- Guard hook koristi `bash`. Na Windowsu to zahtijeva Git for Windows, koji Claude Code ionako koristi.
- Verzija 0.3.0: profili procesa, komanda `harden`, proporcionalni testovi, kontinuiran rad i zaštita od zastoja. Sve izmjene su u [CHANGELOG.md](CHANGELOG.md). Kod izmjena povećaj `version` u `.claude-plugin/plugin.json` i `marketplace.json`.

## English quick start

```bash
claude plugin marketplace add harymedire/paiasa-dev
```

```bash
claude plugin install paiasa-dev@paiasa-dev
```

Then, in your code repository, run `/paiasa-dev:dev-team <prompt file | prompts folder (plan/prompts) | handoff folder | pasted task | resume | release | maintain | harden [module|all]> [--profile prototype|standard|production]`. Default profile: standard.

## License

MIT
