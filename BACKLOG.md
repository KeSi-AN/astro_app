# Backlog: left over from each phase

Things deliberately left out, not verified, or waiting on the astrologer. Each item notes why it was left and what would close it. Update this file at the end of every phase.

Legend: **[astrologer]** needs the astrologer's input · **[phone]** needs a check on the device · **[decision]** needs a decision from you.

---

## Phase 0: Engine foundations
- [ ] **KP Khullar ayanamsa.** Swiss Ephemeris has no built-in mode for it. Needs its reference value (epoch and value at epoch) to add as a user-defined mode. Source: switch AstroSage's ayanamsa to KP Khullar and read the value off its PDF or Avakhada screen.
- [ ] **User-defined ayanamsa in the UI.** The engine supports it (`Ayanamsa.user`), but there is no settings screen to enter the epoch and value.
- [ ] **[decision] Swiss Ephemeris licence.** AGPL is fine while this is a private tool. Before any public or paid release: buy the Professional licence (CHF 700) or replace `SwephEphemeris` behind the `Ephemeris` interface.

## Phase 1: Chart entry, atlas, saved charts
- [x] **[phone] War-time birth (1942–45).** Checked on the phone 2026-11-25: Kolkata 1943 pasted in shows UTC+06:30 with the war-time switch on; Mumbai 1950 shows the Bombay Time warning.
- [ ] **Place names are Latin script only.** GeoNames has no Devanagari names, so typing "लखनऊ" finds nothing (the app says to type in English letters). A transliteration table for Indian place names would fix it.
- [ ] **Release APK size.** The debug APK is ~224 MB (debug + 24 MB atlas). Make a release build with ABI splits and check its size.
- [ ] **Paste dialog reads the clipboard.** It pre-fills from the phone clipboard; take care when taking screenshots so nothing private shows.

## Phase 2: Chart screen
- [x] Ghatak / Favourable: moved to Phase 6.
- [ ] **Varga variants as settings.** Only Parashara rules are implemented (e.g. no Parivritti hora, Jagannatha drekkana, alternative D24 start). Add if the astrologer uses them. **[astrologer]**

## Hindi
- [ ] **Hindi PDF/report language.** Comes with Phase 10 (PDF kundli).
- [ ] **[astrologer] Hindi terminology review.** All terms were written from standard Hindi jyotish vocabulary; the astrologer should skim the screens and flag any word they use differently (e.g. स्पष्ट, दिनमान, कारकत्व).

## Phase 3: Divisional charts and dashas
- [ ] **[astrologer] Mars D7 in TestChart.** BPHS gives Virgo (Mars at Leo 4°51′ is past the first saptamsha at 4°17′); AstroSage shows Leo. Ours follows the rule; confirm the astrologer agrees.
- [ ] **[astrologer] Chara dasha Aquarius.** We use K.N. Rao's co-lord rule (Saturn, 11 years); AstroSage gives 0 years. Confirm which the astrologer expects.
- [ ] **Yogini antardasha dates in AstroSage** are one month early (an AstroSage bug). Nothing to do on our side; just remember when comparing.
- [ ] **More dashas** (Ashtottari, Kalachakra, Narayana and others) are in the "later" list of BUILD_PLAN.md.

## Phase 4: Strength
- [ ] **[astrologer] Shadbala ranks differ from AstroSage** for 5 of 7 planets (Sun and Saturn agree). AstroSage shows ranks only, so the cause can't be pinned down from its screens. Our method: BPHS ch. 27 as computed by B.V. Raman (all choices listed in DIVERGENCES.md). Next step: compare our full values against another program that prints numbers (Jagannatha Hora, Parashara's Light) or the astrologer's reference book.
- [ ] **[astrologer] Bhava bala ranks:** 7 of 12 houses agree with AstroSage. Same next step as above.
- [ ] **Ishta / Kashta phala** are not built yet (they come from uchcha and cheshta bala).

## Phase 5: KP
- [ ] **CIL (sub) column T2.** No consistent rule reproduces AstroSage's T2 from its own data, so it isn't shown. **[astrologer]** Ask how they read it, or which book defines it.
- [ ] **CIL (sub-sub).** AstroSage's columns couldn't be decoded; not built. **[astrologer]**
- [ ] **AstroSage-style 4-step extras.** AstroSage adds "cuspal" notes and conjunction/aspect notes, blanks a planet's own row when other planets sit in its stars, and drops some owned houses. We show the textbook 4-step; add the notes if the astrologer wants them.
- [ ] **KP ayanamsa.** Our default (KP Old) is 24″ from AstroSage's KP positions; sub-sub lords near boundaries can differ. Close once KP Khullar (Phase 0) is added, or confirm which KP ayanamsa the astrologer uses.

## Phase 6: Yogas, doshas, Sade Sati
- [ ] **[astrologer] Gulika / Maandi and the other time-based upagrahas differ a lot from AstroSage** (TestChart: ours Gulika Gemini 3°, AstroSage Virgo 23°). Ours follows BPHS: the day/night is split into 8 parts ruled from the weekday lord (night: 5th lord), Gulika = lagna at the start of Saturn's part, Maandi = at its middle. AstroSage's values fit a sequence that starts from the Sun regardless of weekday, plus an unexplained 38-minute offset. Ask which rule the astrologer follows (Gulika is widely used in South India), then add it as a setting. The five Sun-based upagrahas (Dhuma… Upaketu) match AstroSage.
- [ ] **[astrologer] Deeptadi avastha** differs from AstroSage for most planets. Ours: Phaladeepika by dignity (exalted Deepta, own Swastha, great friend Mudita, friend Shanta, neutral Deena, enemy Dukhita, debilitated Khala, combust Kopa). AstroSage's values follow no dignity mapping we could find. Baladi and Jagratadi match AstroSage exactly.
- [ ] **Maala yoga.** AstroSage marks it present for TestChart; the Nabhasa Mala definition (benefics in three kendras) is not met, so AstroSage uses another definition. Not implemented until we know which.
- [ ] **Ghatak chakra** (moved here from Phase 2). Still needs a verified table (month, tithi, weekday, nakshatra, prahar, lagna for each Moon sign). Source options: the astrologer's panchang/book, or AstroSage's Ghatak screen for 12 charts (one Moon sign each).
- [ ] **Guru Chandala** shows "present" for TestChart (Jupiter with Ketu in Leo); AstroSage doesn't list this yoga at all, so it can't be compared.
- [ ] **More yogas.** About 30 are implemented (all with their source). The plan mentioned ~40; add the ones the astrologer uses most (e.g. Lakshmi, Shubha/Papa Kartari, Nabhasa yogas).
- [ ] **Mangal dosha cancellation rules** vary by tradition; ours: Mars own/exalted, with Jupiter, with Moon, and the house-and-sign exceptions. **[astrologer]** confirm the list.

## Phase 7: Panchang and muhurta
- [x] Checked against AstroSage (fixture 005, New Delhi): times within 1–2 min, all 24 Ekadashis, Purnima, Pradosh, Shivaratri, Bhadra, horas, chogadias. Viewed on the phone in Hindi.
- [ ] **Panchak end time.** AstroSage ends Panchak on 21 Nov at sunrise; ours ends when the Moon leaves Revati (22 Nov 05:55). Ask the astrologer which they follow; capture another month to see AstroSage's rule.
- [ ] **Do Ghati names.** AstroSage uses a different list of 30 muhurta names grouped by prahar (Pratah, Sangav, Madhyahna, Aparahna, Sayan, Pradosh, Ratri, Nishita, Arunodaya). Ours uses the Muhurta Chintamani names. Add AstroSage's list and the prahar column if the astrologer reads it that way.
- [ ] **Dushta muhurta, Kantaka/Mrityu, Yamaghanta, Kalavela, Disha Shoola, Tarabala/Chandrabala** (shown by AstroSage) are not built yet.
- [ ] **Sankashti and Amavasya/Sankranti lists** were not captured from AstroSage; only internal checks.
- [ ] **Pradosh June–July 2026** not captured from AstroSage (screens skipped).
- [ ] **[astrologer] Vrat tradition.** The rules now match AstroSage (viddha Ekadashi). If the astrologer follows a different tradition, add a setting.
- [ ] **Samvatsara name** (60-year cycle), **Ritu/Ayana** not shown yet (AstroSage shows Ritu).
- [ ] **Durmuhurta, Varjyam, Amrit Kaal** (South Indian periods) not built.

## Phase 8: Matching
- [ ] **[phone] Compare with AstroSage** for at least 10 couples (BUILD_PLAN asks 10): per-koota points, total, Mangal and the porutham list. **3 of 10 done** (fixtures 006–008: 15, 24.5 and 26/36, every koota matches). The in-app Matching screen also showed 15/36 for couple 1 on the phone.
- [ ] **AstroSage's yoni table is not the standard one.** Three cells checked so far differ from the common table: Cat×Monkey 2, Elephant×Cat 3, Elephant×Monkey 2 (the common table gives 3, 2, 3). We now use AstroSage's values for these, but its other 88 pairs are unknown. Pick couples whose yoni pair hasn't been seen yet (the YONI tab names the animals). We assume the table is symmetric; that is unverified.
- [ ] **Mangal 'low' level.** AstroSage grades Mangal dosha (e.g. "Low Mangal Dosha" for the girl in fixture 006, where ours says cancelled). Find AstroSage's grading rule.
- [ ] **War-time chart in AstroSage matching.** The girl in fixture 006 was entered without war time / Kolkata; re-check with the correct place.
- [ ] **[phone] Look at the Matching screen in English.** Checked in Hindi on 2026-11-25 (15/36, same as AstroSage).
- [ ] **[astrologer] Table variants.** Vashya and Gana tables differ slightly between books (e.g. boy Deva / girl Rakshasa 1 or 0; Vashya half-points). Ours: the common Drik/AstroSage-style tables. Confirm once compared with AstroSage.
- [ ] **[astrologer] Cancellations (parihara).** Implemented as notes only: Nadi (same rashi different nakshatra; same nakshatra different rashi or pada) and Bhakoot (same lord or mutual natural friends). Other traditions add more (e.g. Gana dosha cancelled by good Graha Maitri).
- [ ] **Porutham rules** (Dina, Mahendra, Stree Deergha thresholds, Rasi count) follow common Tamil practice; verify against AstroSage's Porutham screen or the astrologer.
- [ ] **Enter a partner without saving** (matching currently picks two saved charts).

## Phase 9: Transits
- [x] **[phone] Transit tab** checked on the phone 2026-11-25 in Hindi: ▸ transit labels, stepping, gochara table and search work.
- [x] **[phone] Saturn sign changes** from the transit search match AstroSage's Sade Sati dates to within a day.
- [ ] **[phone] Compare with AstroSage "Transit Today"** planet by planet, and Jupiter's 2026–2030 ingress dates.
- [ ] **[astrologer] Gochara rules.** Good houses and vedha pairs follow Phaladeepika ch. 26 (Sun–Saturn and Moon–Mercury exempt from vedha). Some astrologers also use gochara from the lagna or Kakshya (Ashtakavarga sub-divisions); add if wanted.
- [ ] **Transit search** covers sign changes and exact crossings over natal planets/lagna. Not yet: aspects onto natal points, house ingress from the lagna, nakshatra changes.
- [ ] **Transit on Moon chart / varga charts** (only the lagna chart is overlaid).

## Phase 10: PDF kundli
- [ ] **Replace the test letterhead on the phone.** "Pt. Test Sharma" was typed in Settings → Letterhead during testing. Put in the astrologer's real name, phone, address and logo.
- [ ] **[phone] Logo picking not tried.** It wasn't tried, because the gallery picker would show personal photos on screen. Pick a PNG or JPEG logo and check it on the cover (64 pt) and in the page header (26 pt). HEIC/WebP files may be skipped silently (an unsupported format means no logo).
- [ ] **Release-build timing.** A full Hindi report (15 pages) took 4.1 s on the Moto in a debug build, and English took about 1.2 s on the PC. Time it again in a release build (BUILD_PLAN target: under 5 s).
- [ ] **Hindi text is drawn as images** (the pdf package can't shape Devanagari). It looks right and prints sharply (288 dpi), but Hindi words can't be searched or copied in the PDF, and the file is about 1.9 MB against about 90 KB for English. A shaping engine (HarfBuzz) for the PDF would fix both.
- [ ] **[phone] English report and South/East chart styles** were checked only on the PC render, not on the phone.
- [ ] **Section choices are not saved** between app launches (remembered while the app runs).
- [ ] **[astrologer] Content wishes.** Should it include a remarks/predictions page written by the astrologer, the current transits page, or Avasthas/Upagrahas/Arudhas? Are these the right sections in the right order? The pages are 15 for a full report.
- [ ] **Matching report PDF** (Ashtakoota + Mangal) is not built; only the birth kundli is.

## Phase 11: Clients, notes, appointments, backup
- [ ] **[phone] Reminder delivery not yet seen.** Saving a follow-up opened Android's notification-permission prompt, which was left for the user to answer. After allowing, check that the alarm is scheduled (`adb shell dumpsys alarm | grep kesian`) and that a reminder actually arrives. Alarms are inexact (no exact-alarm permission), so they may be a few minutes late.
- [ ] **[phone] Backup to Drive and restore not tried on the phone**, because the share sheet and file picker show personal apps and files. The unit test covers create → restore, including moving the logo to the new phone's folder. Still to try: Save to Drive, then restore from Drive (the app restarts its services afterwards).
- [ ] **Automatic backups.** shop_app makes a nightly backup and copies it to Downloads; this app only backs up when asked. The Backup screen turns red after 7 days without one.
- [ ] **Test data on the phone:** "Test Client" (linked to TestChart, one ₹501 consultation with a follow-up on 25 Dec) and the "Pt. Test Sharma" letterhead. Delete them before handing the phone to the astrologer.
- [ ] **App name and icon.** The launcher and the permission prompt say "astro_app". Pick a proper name and icon.
- [ ] **Chart screen doesn't show its client.** There's no way to link a chart to a client from the chart side. Linking is done from the client page (new chart, or link a saved chart).
- [ ] **Walk-ins.** An appointment without a client can't be turned into a client in one tap.
- [ ] **Not built:** importing contacts from the phone; merging duplicate clients; a month calendar view; repeating appointments; fee receipts. The "Reports sent" list logs only completed Share and Print actions, not previews.
