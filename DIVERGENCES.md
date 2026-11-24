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
