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

- AstroSage couples (fixtures 006–008): all eight kootas and the totals match, 15, 24.5 and 26/36. Fixtures 007 and 008 are run by the `AstroSage couple` tests and hold both birth details.
- Yoni cells checked against AstroSage: Cat×Monkey 2, Elephant×Cat 3, Elephant×Monkey 2.

**Phone (2026-11-25):** the Matching screen shows 15/36 for couple 1, as AstroSage. **7 more AstroSage couples are pending** (see BACKLOG).

**Phone:** chart list → heart icon (कुंडली मिलान) → pick boy and girl.

## Phase 9: Transits
**Automated** (`packages/jyotish_core/test/transit_test.dart`)
- Transit at the birth moment equals the natal chart (positions and houses); Moon is 1st from itself.
- SAV and BAV bindus in the transit table come from the natal Ashtakavarga.
- Gochara: Saturn in the 3rd from the Moon is good (finds a real date by searching ingresses).
- Crossings land exactly on the target (< 0.0001°), include retrograde passes; the Sun has 12 sign ingresses a year; Rahu's are all retrograde.

**Phone:** chart → Transit tab (गोचर): step by day/month/year or swipe on the chart; Today; gochara table colours; search (e.g. Saturn over natal Moon, next 30 years) and "Show".

**Checked on the phone (2026-11-25):** the Transit tab works in Hindi. Saturn's sign changes match AstroSage's Sade Sati dates to within a day.

## Phase 10: PDF kundli
**Automated** (`app/test/report_test.dart`, needs `packages/jyotish_core/native/sweph.dll`)
- Latin text (with ° ′ ″ ·) uses the embedded Roboto; Devanagari is detected as needing images.
- Full English kundli: 15–25 pages, valid PDF, written to `app/build/report_test_en.pdf` to look at.
- Full Hindi kundli: 15–25 pages, more than 50 strings drawn as images, none left pending after the passes. Written to `app/build/report_test_hi.pdf`. On the PC the Hindi shows as boxes, because the test font has no Devanagari; check Hindi on the phone.
- One section only gives the cover plus one page.

**Phone:** Settings → Letterhead (लेटरहेड): name, title, phone, address and logo, then Save. Open a chart → PDF icon → tick the sections, pick the language → PDF बनाएँ. The preview shows the page count and how long it took; Print opens Android's print screen (A4), and Share opens the share sheet (WhatsApp).

**Checked on the phone (2026-11-25):**
- The Hindi kundli for TestChart: 15 pages in 4.1 s (debug build), about 1.9 MB.
- Devanagari is correctly shaped in the charts, tables and yoga text.
- The letterhead appears on every page.
- The print preview shows 1/15 on ISO A4.
- The PDF was pulled with `adb exec-out run-as com.kesian.astro_app cat cache/share/<name>_kundli.pdf` and checked page by page.

## Phase 11: Clients, notes, appointments, backup
**Automated** (`app/test/clients_test.dart`)
- **Upgrade:** a schema 2 database (DDL in `test/fixtures/v2_schema.sql`) opens at schema 3, keeps its charts and can link them.
- **Family charts:** link and order by relation ("self" first), unlink. Deleting a client keeps the charts and only clears the link.
- **Client search:** reaches the notes of consultations and charts. Each list row shows the chart count, the next appointment and the unpaid total.
- **Appointments:** today's list, the unpaid list (cancelled ones excluded), follow-ups, marking paid.
- **Reminder times:** 30 minutes before the start and 10:00 on the follow-up day, future times only, no start reminder once done.
- **Money:** Indian digit grouping (₹12,34,567).
- **Backup round trip:** manifest counts; restore replaces the data; the logo file comes back and the logo path points at the new phone's folder; a non-backup file is rejected.

**Phone:** bottom tabs कुंडलियाँ / ग्राहक / मुलाक़ातें.
- **Clients:** ग्राहक → नया ग्राहक → save opens the client page. Use + to add a new or saved chart with its relation, and नई मुलाक़ात to book a consultation.
- **Appointments:** the मुलाक़ातें tab has Today (plus follow-ups this week), Upcoming, Past and Unpaid. Each row's ⋮ menu marks it done, paid, missed or cancelled.
- **Backup:** Settings → बैकअप → अभी बैकअप लें (share sheet → Save to Drive). बैकअप फ़ाइल से वापस लाएँ restores and restarts the app.

**Checked on the phone (2026-11-25):**
- The v2 → v3 upgrade kept the 3 charts.
- Created a client and linked TestChart as स्वयं.
- Booked a consultation with notes and ₹501. It showed as due (बाकी ₹501), and "Mark paid" turned it to मिला ₹501 ✓.
- The Today list shows it.
- Saving a follow-up asks for the notification permission.
- **2026-11-26:**
  - A walk-in booked for 02:15 gave an exact alarm at 01:45. The notification "मुलाक़ात: Reminder test" arrived at 01:45:03; check with `adb shell dumpsys notification --noredact | grep astro_app`.
  - Back up now wrote a valid zip (manifest: schema 3, 3 charts, 1 client, 2 appointments).

## More dashas and the Drik panchang (2026-11-26)
**Automated**
- `jyotish_core/test/nakshatra_dashas_test.dart`:
  - The 28-segment wheel with Abhijit.
  - Ashtottari start lord and balance at the start of Ardra, mid Pushya, mid Abhijit and Ashwini.
  - Antardashas fill their mahadasha.
  - Count-based starts for every conditional dasha.
  - The cycle totals (108, 116, 112, 105, 100, 84, 72, 60, 36).
- `jyotish_core/test/day_extras_test.dart`: against Drik Panchang, New Delhi, 26 Nov – 1 Dec 2026, times within 2 minutes (Baana within 7).
  - Every special time on 26 Nov, plus Sarvartha Siddhi, Ravi Pushya, Ravi Yoga, Ganda Moola, Varjyam and Amrit Kalam on 27 Nov – 1 Dec.
  - Baana, Anandadi and every nivas.
  - Samvat names, Pravishte, ritu and the epochs.
  - All 15 Panchaka Rahita segments, and Gowri day and night.
  - Chandrabalam and Tarabalam grades.

**Phone:**
- Chart → Dasha tab: the dropdown lists all 12 systems; a conditional dasha shows its BPHS rule and whether it applies.
- PDF: an "Other dashas" page.
- Panchang → दिन has the new cards: ritu & ayana, auspicious and inauspicious times, Anandadi, nivas & shool, other calendars. New chips: गौरी, पंचक रहित, चन्द्र / तारा बल.

**Checked on the phone (2026-11-26):** the Day view, Gowri, Panchaka Rahita and Chandra/Tara bala for 26 Nov match Drik Panchang's screens.

## Drik Panchang, second pass (2026-11-26)
**Automated**
- `jyotish_core/test/drik_days_test.dart`: 38 days of Drik Panchang, New Delhi, 26 Nov 2026 – 9 Jan 2027 (`tools/drik/drik_days.json`).
  - Every special time: count and start/end within 2 minutes (7 near the Sun changing nakshatra).
  - Aadal/Vidaal.
  - Anandadi and Tamil yoga, Kumbha Chakra, Jeevanama, Netrama.
  - Homahuti, Agnivasa, Shivavasa, Chandra Vasa.
  - Pravishte, Disha Shool, Rahu Vasa, National Nirayana date.
- `jyotish_core/test/festivals_test.dart`:
  - The 46 festivals of 2026 on Drik's dates.
  - Eclipses of 2025–26 at New Delhi with visibility and sutak (7 Sep 2025 sutak 12:57, for children and the sick 18:35; 3 Mar 2026 sutak 06:20, moonrise 18:24).
  - The Mantri Mandala of Vikram 2082 and 2083.
  - The Brihaspati samvatsara changes on 25 Apr 2025 and 21 Apr 2026.

**Phone (2026-11-26):**
- The Panchang Day view for 26 Nov shows Tamil yoga Marana, full life, two eyes, Kumbha North ✗, the Mantri Mandala of 2083, Raudra samvatsara and National Nirayana Margashirsha 12, all as Drik.
- The new त्योहार (festivals) and ग्रहण (eclipses) chips list 2026 correctly.
