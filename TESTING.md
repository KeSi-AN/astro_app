# Testing guide: per phase

How to re-check each phase later: the automated tests (what they prove and how to run them) and the manual checks on the phone. Update this file at the end of every phase.

## Running everything

```powershell
# one-time on a new PC: build the Swiss Ephemeris DLL for PC tests
tools\build_sweph_dll.bat
```
```powershell
cd packages\jyotish_core; flutter test
```
```powershell
cd packages\birth_input; dart test
```
```powershell
cd app; flutter test
```

Flutter lives at `C:\Users\addya\flutter\bin` (add it to PATH or call it by full path).

## Reference ("golden") charts

Stored in `tools/golden/*.json`. Each file records where its numbers came from (AstroSage screen and screenshot name in `REA/astrosage/live/`).

| Fixture | Chart | What it carries |
|---|---|---|
| 001_testchart_agra | 23-11-2026 23:21:37 Agra (27N09 078E00) | Planets, ayanamsa, obliquity, panchang, Avakhada |
| 002_golden_mumbai_1950 | 03-03-1950 05:10 Mumbai, before sunrise | Planets, panchang (Hindu weekday = previous day), Avakhada |
| 003_golden_kolkata_1943_wartime | 15-08-1943 14:30 Kolkata, war time | Planets with +1h war time, panchang, Avakhada |
| 005_panchang_delhi_2026_11_25 | New Delhi, 25 Nov 2026 (panchang, not a birth chart) | Day panchang, kaals, horas, chogadias, Bhadra, Panchak, Rahu Kaal week, 2026 vrat lists |
| 004_testchart_paste_vargas_dashas | 23-11-2026 23:21:00 Agra (27N10 078E01) | 16-varga table, Yogini, Chara, Ashtakavarga, bala ranks, all KP tables |

To add a chart: enter it in AstroSage with **Save unticked**, copy the numbers into a new JSON file following an existing one, and run the tests. Every test file loops over all fixtures that carry the relevant section.

Allowed differences (AstroSage uses a lower-precision ephemeris) are set per fixture in `tolerancesArcSec` and explained in `DIVERGENCES.md`.

---

## Phase 0: Engine foundations
**Automated** (`packages/jyotish_core/test/`)
- `golden_rasi_test.dart`: for every fixture, sign, nakshatra, pada and retrograde must match exactly, degrees within tolerance. Also checks the Julian day, ayanamsa and obliquity.
- `model_test.dart`: sign and nakshatra boundaries, padas, whole-sign houses, bhava ranges across 0°, d°m′s″ rounding and parsing, LMT correction.

**Phone:** open TestChart → Planets tab; compare with AstroSage's Planets screen.

## Phase 1: Chart entry, atlas, saved charts
**Automated**
- `packages/birth_input/test/birth_text_parser_test.dart` (21 tests): WhatsApp-style text, labelled and unlabelled; day-first dates and the notes for ambiguous ones; 2-digit years; Hindi transliterated time words (subah, shaam, raat); Devanagari labels, digits and month names; 12 am/pm; gender words.
- `packages/birth_input/test/time_resolver_test.dart` (10 tests): IST; war time 1942–45 on and off; LMT before 1906; Bombay and Calcutta time suggestions; New York DST; non-existent and repeated local times; manual offset.
- `app/test/atlas_repository_test.dart`: Agra first with the right coordinates and zone; villages; ", state" filter; world cities; wildcard safety.
- `app/test/chart_repository_test.dart`: save/read round trip, newest-first list, search, duplicate, delete.
- `app/test/formatters_test.dart`: date, time and offset input parsing and display.

**Phone:** New chart → Paste details → "TestChart 23/11/2026 23:21:37 Agra" → Save & open. Also enter a 1943 Kolkata birth and check the war-time switch (see BACKLOG).

## Phase 2: Chart screen
**Automated**
- `golden_analysis_test.dart`: per fixture, tithi, paksha, yoga, karana, Hindu weekday, sunrise/sunset (±60 s), ishtkaal, Avakhada (varna, vashya, yoni, gana, nadi, paya), dasha balance (±10 days).
- `rules_test.dart`: KP lords, natural/temporal/compound relationships, dignities, combustion orbs, navamsha, panchang names, years-to-Y/M/D.
- `app/test/chart_geometry_test.dart`: North/South/East cells tile the square, text stays inside cells, fixed sign positions in South and East, label markers.

**Phone:** Chart tab in North, South and East; tap a planet for its sheet; Details tab against AstroSage's Person Details and Avakhada screens; Friendship tab against AstroSage's.

## Hindi
**Automated**
- `app/test/l10n_test.dart`: every English string has a Hindi translation with the same placeholders; every engine term (grahas, rashis, nakshatras, tithis, yogas, karanas, weekdays, dignities, relations, karakas, ayanamsas, vargas, yoginis, dasha levels) has a Devanagari name; all Avakhada values translated; chart abbreviations stay short.
- Hindi paste input: see Phase 1.

**Phone:** Settings → Language → हिंदी; walk every tab; open the date picker (it must be Hindi too).

## Phase 3: Divisional charts and dashas
**Automated**
- `varga_dasha_test.dart` (14 tests): BPHS rules for D2–D60 including the unequal D30; D9 by explicit rule equals continuous counting; each division keeps one sign. Vimshottari is contiguous and covers 120 years, its sub-periods fill the parent to 5 levels, and Moon-mahadasha antardasha end dates are within 10 days of AstroSage. Yogini start and 36-year cycle. Chara worked by hand for TestChart.
- `golden_varga_dasha_test.dart`: fixture 004, all 160 varga cells against AstroSage with the 5 documented boundary differences; Yogini mahadasha dates; Chara order, years and antardasha order (Aquarius documented).

**Phone:** Vargas tab table; Chart tab D-chips; Dasha tab Vimshottari/Yogini/Chara, Today, Go to date.

## Phase 4: Strength
**Automated** (`golden_strength_test.dart`)
- Bhinnashtakavarga totals fixed by the tables (48, 49, 39, 54, 56, 52, 39; SAV 337).
- Fixture 004: all 84 BAV cells equal AstroSage's.
- Shadbala components within their ranges; prints our values next to AstroSage's ranks.

**Phone:** Strength tab: Ashtakavarga, Shadbala, Bhava bala; Chart tab SAV switch.

## Phase 5: KP
**Automated** (`golden_kp_test.dart`)
- 249 horary numbers: increasing, every sign boundary is a start.
- Fixture 004: sign/star/sub lords of planets, lagna and 12 cusps; sub-sub with the 3 documented boundary flips; cusp degrees within 2′; 4-level significations; house significators; ruling planets; Nakshatra Nadi for 9 planets; CIL (sub) T1/T3/T4 for 12 cusps; 4-step chain.
- Prints offsets for KP New and KP Old against AstroSage (why KP Old is the default).

**Phone:** KP tab, every section; horary number 123 should give lagna Virgo 26°06′40″ (start of Chitra's Jupiter sub).

## Phase 6: Yogas, doshas, Sade Sati
**Automated** (`packages/jyotish_core/test/golden_phase6_test.dart`)
- Navatara cycles from the birth star; Baladi and Jagratadi boundaries.
- Fixture 004 against AstroSage:
  - the five Sun-based upagrahas (Dhuma, Vyatipata, Parivesha, Indrachapa, Upaketu) within 2′;
  - Baladi and Jagratadi for all seven planets;
  - all twelve arudha padas (A1/AL … A12/UL);
  - Mangal dosha (found from the lagna, cancelled by Jupiter, so absent overall, as in AstroSage) and Kaal Sarp (absent);
  - the named yogas AstroSage lists (Malavya, Saraswati, Vosi, Parvata, Anapha, Dhana, Parashari Raja);
  - twelve Sade Sati / Small Panoti periods (sign, kind and dates within 3 days).
- A yoga that did not form is never marked cancelled.
- `app/test/l10n_test.dart`: every yoga name and rule, upagraha, avastha and navatara name has Hindi.

**Phone:** Yogas tab (योग): every section. Doshas are always listed; turn on "show absent" to see every yoga checked. Sade Sati highlights the period running now.

## Phase 7: Panchang and muhurta
**Automated** (`packages/jyotish_core/test/panchang_test.dart`)
- Tithi, nakshatra, yoga and karana spans are contiguous, numbered in order and cover sunrise to the next sunrise.
- 24 horas starting with the weekday lord in Chaldean order; night horas start at sunset.
- Chogadia: the standard Sunday (day and night) and Monday sequences.
- Rahu Kaal by weekday; Abhijit is the 8th of 15 day muhurtas.
- Lagna table covers the whole day with 12–13 rows.
- Bhadra periods are Vishti karana; Panchak is the Moon in Aquarius/Pisces and lasts 4–6 days.
- 2026 vrat list counts (12 Sankrantis, ~24 Ekadashis, 12–13 Purnima/Amavasya/Sankashti/Shivaratri, ~25 Pradosh).
- Prints the full panchang for 25 Nov 2026 at Agra.
- `app/test/l10n_test.dart`: Hindi for lunar months, chogadias, the 30 muhurtas, kaals and vrats.

- `packages/jyotish_core/test/golden_panchang_test.dart`, fixture 005 (New Delhi, 25 Nov 2026) against AstroSage, within 2 min:
  - sun/moon rise and set;
  - tithi, nakshatra, yoga and karana end times; months; weekday;
  - Rahu Kaal, Yamaganda, Gulika (and Rahu Kaal for the next 7 days); no Abhijit on Wednesday;
  - hora lords and times, chogadia day and night;
  - Bhadra periods for November; Panchak start;
  - 2026 Ekadashi (24), Purnima, Pradosh, Masik Shivaratri dates.

**Phone:** chart list → calendar icon (पंचांग) → choose a place once; step dates; each section.

## Phase 8: Matching
**Automated** (`packages/jyotish_core/test/matching_test.dart`)
- Yoni table is symmetric, 4 on the diagonal, sworn enemies 0.
- Rajju cycle and Vedha pairs.
- Couple (fixture 002 boy × 003 girl): kootas 1, 2, 1.5, 2, 0.5, 1, 7, 0 = 15/36, as AstroSage; Nadi dosha not cancelled.
- Totals and each koota within range; symmetric kootas unchanged when roles swap.
- All ten poruthams evaluated.
- `app/test/l10n_test.dart`: Hindi for kootas, poruthams and rajju.

- AstroSage couple (fixture 006): all eight kootas and the 15/36 total match after setting Cat×Monkey yoni to 2.

**More AstroSage couples pending** (see BACKLOG).

**Phone:** chart list → heart icon (कुंडली मिलान) → pick boy and girl.

## Phase 9: Transits
**Automated** (`packages/jyotish_core/test/transit_test.dart`)
- Transit at the birth moment equals the natal chart (positions and houses); Moon is 1st from itself.
- SAV and BAV bindus in the transit table come from the natal Ashtakavarga.
- Gochara: Saturn in the 3rd from the Moon is good (finds a real date by searching ingresses).
- Crossings land exactly on the target (< 0.0001°), include retrograde passes; the Sun has 12 sign ingresses a year; Rahu's are all retrograde.

**Phone:** chart → Transit tab (गोचर): step by day/month/year or swipe on the chart; Today; gochara table colours; search (e.g. Saturn over natal Moon, next 30 years) and "Show".
