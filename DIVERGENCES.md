# Known differences from other programs

Every place our numbers differ from a reference program, why, and which setting (if any) reproduces it.

## AstroSage (Android v32.6), checked 2026-11-24 with golden chart 001 (TestChart, Agra)

| Quantity | Ours (Swiss Ephemeris, apparent) | AstroSage | Cause |
|---|---|---|---|
| Sun…Venus, Mars, Lagna | — | 8–30″ different | AstroSage uses its own lower-precision ephemeris. No Swiss Ephemeris flag combination (true geometric position, no aberration, no nutation) reproduces it: residuals stay 8–30″. |
| Jupiter, Saturn | — | 1.5′–2.5′ | Same; error grows for slow outer planets. |
| Uranus, Neptune | — | 2′–3.5′ | Same. |
| Pluto | — | 11′ | Same (simplified Pluto theory). |
| Rahu/Ketu | mean node | mean node, 21″ different | AstroSage uses the **mean** node (true node is 17′ away). Our default is mean to match. |
| Ayanamsa (Lahiri) | 24°14′06″ (true, with nutation) | 24°13′56″ | AstroSage prints the **mean** ayanamsa; Swiss Ephemeris mean value is 24°13′58″. Sidereal positions are unaffected (nutation cancels). |
| Obliquity | 23°26′16″ true / 23°26′09″ mean | 23°26′09″ | AstroSage prints mean obliquity. |

**Decision:** we keep Swiss Ephemeris apparent positions (the standard used by Jagannatha Hora, Parashara's Light and astro.com). Signs, nakshatras, padas and retrograde flags all agree with AstroSage. Golden fixtures from AstroSage carry wider degree tolerances; fixtures from Jagannatha Hora (to be added) use 2″.

Practical impact: a planet within ~1′ of a sign/nakshatra/pada boundary (~2.5′ for Jupiter/Saturn, ~11′ for Pluto) can land differently in AstroSage. When the astrologer reports a mismatch, check that first.

## Atlas coordinates (Phase 1, 2026-11-24)

Our atlas is GeoNames; AstroSage uses its own. The same town can differ by a few arc-minutes:

| Place | Ours (GeoNames) | AstroSage | Effect on TestChart |
|---|---|---|---|
| Agra | 27°11′N 078°01′E | 27°09′N 078°00′E | Lagna 29°15′39″ vs 29°14′14″ Cancer (+1′25″) |

1′ of longitude = 4 s of time ≈ 1′ of lagna. When comparing a chart with AstroSage, enter AstroSage's coordinates via "Enter coordinates manually" in the place search, or expect the lagna (and bhava cusps) to move by about as many arc-minutes as the coordinates differ. Planets are not affected (geocentric).

## Panchang at birth (Phase 2, 2026-11-24)

Checked against three AstroSage charts (Agra 2026, Mumbai 1950 pre-sunrise, Kolkata 1943 war time): tithi, paksha, yoga, karana, Hindu weekday, varna, vashya, yoni, gana, nadi and paya all match.

| Quantity | Difference | Cause |
|---|---|---|
| Sunrise / sunset | up to 48 s (Mumbai 1950); usually ≤ 20 s | AstroSage's own sunrise routine. Both use the upper limb with refraction (our default); the "Hindu" disc-centre definition would differ by ~4 minutes. |
| Ishtkaal | ≤ 2 pal (1 pal = 24 s) | Follows from sunrise. |
| Dasha balance | ≤ 10 days | Follows from AstroSage's Moon being up to ~30″ different (1″ of Moon ≈ 4 hours of Vimshottari balance for a 20-year lord). |
| Julian day | AstroSage prints the day number of the local civil date, not of the UT moment | Display convention only. |

## Vargas and dashas (Phase 3, checked 2026-11-25, fixture 004)

AstroSage TestChart re-entered through its paste box (Agra 27N10 078E01, 23:21:00).

| Item | Ours | AstroSage | Cause |
|---|---|---|---|
| 160 varga cells (16 vargas × lagna + 9 grahas) | 155 match | — | — |
| Moon D12, D24, D30, D60 | 11, 1, 7, 3 | 10, 12, 3, 2 | Moon is at Aries 25°00′, a division edge in all four; AstroSage's Moon is ~30″ behind ours and falls just below it. Boundary case, not a rule difference. |
| Mars D7 | Virgo | Leo | Mars at Leo 4°51′ is past the first saptamsha (4°17′8″); BPHS gives Virgo. AstroSage's value would follow from using whole degrees (4°) — looks like an AstroSage quirk. |
| Vimshottari | — | — | Antardasha dates within 10 days (Moon difference). |
| Yogini mahadashas | — | — | Same order and end dates (within days). |
| Yogini antardasha dates | rule dates | one month earlier, except the last of each mahadasha | Every AstroSage antardasha end date except the one equal to the mahadasha end is exactly one month early (e.g. Ulka/Ulka 8/6/28 vs 8/7/28) — an AstroSage display bug (month index). |
| Chara dasha (K.N. Rao) | 11 of 12 signs identical | — | Order, years and antardasha order match. |
| Chara Aquarius | Saturn → 11 years | 0 years | Aquarius has two lords; Rahu sits in Aquarius, Saturn in Pisces. K.N. Rao: if one lord is in the sign, use the other (Saturn). AstroSage appears to use Rahu and prints 0 years (it does apply "lord in own sign = 12 years" to Libra). |

## Strength (Phase 4, 2026-11-25, fixture 004)

- Ashtakavarga: all 84 BAV cells match AstroSage exactly; SAV total 337.
- Shadbala: AstroSage shows ranks only. Ours follows BPHS ch. 27 / B.V. Raman with all components shown. Ranks agree for Sun (6) and Saturn (7); the middle five differ (ours Mo1 Ju2 Me3 Ve4 Ma5, AstroSage Ve1 Ma2 Mo3 Ju4 Me5). Choices: Moon paksha doubled, Sun ayana doubled, cheshta kendra from heliocentric angle, year/month lords from Mesha/sign sankranti weekdays, kendradi by Sripati bhava, Jupiter/Mercury drishti in full.
- Bhava bala ranks: 7 of 12 houses agree with AstroSage.

## KP (Phase 5, 2026-11-25, fixture 004)

AstroSage's KP module ignores the chart's ayanamsa and uses a KP ayanamsa. Against it, after removing each planet's own ephemeris difference: KP-New (Krishnamurti–Senthilathiban) is 48″ behind, KP-Old (Krishnamurti) 24″ ahead. Our KP default is therefore KP-Old (a separate "KP ayanamsa" setting).

| Item | Result |
|---|---|
| Sign, star, sub lords of 9 planets, lagna and 12 cusps | all match |
| Sub-sub lords | match except Saturn, cusp 2, cusp 8 (sub-subs are minutes wide; AstroSage's Saturn is ~90″ off, cusps ~40″) |
| Planet significations, 4 levels (Placidus occupancy/ownership, nodes own nothing) | all match |
| House significators | all match |
| Ruling planets at birth | all match |

| Nakshatra Nadi (9 planets; nodes take sign lord, star lord, conjunct and aspecting planets) | all match |
| CIL (sub) T1, T3, T4 for 12 cusps | all match |
| CIL (sub) T2 | not shown: no consistent rule reproduces AstroSage's column from its own data |
| CIL (sub-sub) | not built: AstroSage's columns could not be decoded |
| 4-step | ours: textbook chain (planet → star lord → sub lord → sub lord's star lord), each with Nakshatra Nadi houses. AstroSage adds "cuspal" and conjunction/aspect notes, blanks a planet's own row when other planets sit in its stars, and drops some owned houses (e.g. Jupiter's 9th, Venus's 4th) — not reproduced. |
