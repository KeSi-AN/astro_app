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
