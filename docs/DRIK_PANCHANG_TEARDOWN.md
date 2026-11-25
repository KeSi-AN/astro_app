# Drik Panchang (Android 2.6.7) teardown: panchang features

Looked at on 2026-11-26 on the Moto (New Delhi, the app's default). Method: the APK string table (57k strings, `apk/strings.txt`) for the feature list, then a live walk of Dainika Panchang and Dainika Muhurta, with screenshots for 26 Nov – 1 Dec 2026 (`live/`, `live/week/`).

Dashas: Drik's Kundali has **Vimshottari only**. No app on the phone shows Ashtottari or the conditional dashas.

## Daily panchang sections (Dainika Panchang)
| Section | Items | In astro_app before? |
|---|---|---|
| Sun & Moon | sunrise, sunset, moonrise, moonset | yes |
| Panchang | tithi, nakshatra, yoga, karana (all with end times), weekday | yes |
| Lunar month, samvat | amanta/purnimanta month, paksha, **Pravishte/Gate**, **Shaka Samvat + name**, **Vikram Samvat + name**, **Gujarati Samvat + name**, Brihaspati samvatsara (Jupiter) | partly (month, shaka, vikram numbers) |
| Mantri Mandala | Raja, Mantri… of the samvat year | no |
| Rashi & Nakshatra | sunsign, **moonsign with change time**, **Surya nakshatra & pada**, **nakshatra pada end times** | partly |
| Ritu & Ayana | **Drik (tropical) and Vedic ritu/ayana, Madhyahna, Dinamana, Ratrimana** | no |
| Auspicious | Abhijit, **Amrit Kalam, Vijaya, Godhuli, Sayahna Sandhya, Nishita, Brahma, Pratah Sandhya, Sarvartha Siddhi, Amrita Siddhi, Ravi Yoga, Ravi/Guru Pushya, Dwipushkar, Tripushkar** | Abhijit only |
| Inauspicious | Rahu, Gulika, Yamaganda, **Dur Muhurtam, Varjyam**, Bhadra, **Ganda Moola, Aadal, Vidaal, Baana** | Rahu/Gulika/Yama/Bhadra |
| Anandadi & Tamil Yoga | **Anandadi yoga (28)**, Tamil yoga (Siddha/Amrita/Marana), Jeevanama, Netrama | no |
| Nivas & Shool | **Homahuti, Disha Shool, Rahu Vasa, Agnivasa, Bhadravasa, Chandra Vasa, Shivavasa**, Kumbha Chakra | no |
| Other calendars | **Kaliyuga, Kali Ahargana, Lahiri ayanamsha, Rata Die, JD, MJD, Julian date, National Civil date**, National Nirayana date | no |
| Dainika Muhurta | Choghadiya, Hora, Lagna, Do Ghati (have); **Chandrabalam, Tarabalam, Panchaka Rahita, Gowri Panchangam**; Panjika Yoga, Jain Pachchakkhan, Pancha Pakshi | partly |

Bold = built in astro_app on 2026-11-26.

## Rules recovered (all reproduce Drik's values for 26 Nov – 1 Dec 2026)
- **Dur Muhurtam:** day muhurtas (day/15) by weekday. Sun 14; Mon 9, 12; Tue 4 plus night muhurta 7; Wed 8; Thu 6, 12; Fri 4, 9; Sat 1, 2.
- **Varjyam / Amrit Kalam:** a 4-ghati window starting at a fixed ghati of the nakshatra's own duration (classical tables). Checked for Mrigashira, Ardra, Punarvasu, Pushya, Ashlesha and Magha.
- **Brahma muhurta:** the 14th night muhurta. **Pratah Sandhya:** from its midpoint to sunrise. **Sayahna Sandhya:** sunset to sunset + 1.5 night muhurtas. **Nishita:** the 8th night muhurta. **Vijaya:** the 11th day muhurta. **Madhyahna:** middle of the day.
- **Godhuli:** Drik shows about 17:21 – 17:49. The best fit is the Sun's centre on the apparent horizon to civil dusk (Sun 6° below), within 1–2 minutes.
- **Baana:** (completed degrees of the Sun in its sign) mod 9: 1 Mrityu, 2 Agni, 4 Raja, 6 Chora, 8 Roga.
- **Panchaka Rahita:** (tithi 1–30 + weekday Sun=1 + nakshatra 1–27 + lagna sign 1–12) mod 9, same mapping as Baana; everything else is Shubha. Segments split at lagna, tithi and nakshatra changes.
- **Anandadi:** 28 yogas counted, with Abhijit included, from the weekday's starting nakshatra (Sun Ashwini, Mon Mrigashira, Tue Ashlesha, Wed Hasta, Thu Anuradha, Fri Uttarashadha, Sat Shatabhisha).
- **Homahuti:** count from the Sun's nakshatra to the Moon's; (count − 1) div 3 → Sun, Mercury, Venus, Saturn, Moon, Mars, Jupiter, Rahu, Ketu.
- **Disha Shool:** Sun W, Mon E, Tue N, Wed N, Thu S, Fri W, Sat E. **Rahu Vasa:** Sun N, Mon NW, Tue W, Wed SW (inferred), Thu S, Fri SE, Sat E.
- **Agnivasa:** (tithi + weekday + 1) mod 4: 0 or 3 Prithvi, 1 Akasha, 2 Patala.
- **Shivavasa:** (2 × tithi + 5) mod 7: 1 Kailash, 2 with Gowri, 3 on Nandi, 4 in Sabha, 5 in Bhojana, 6 in Krida, 0 in Shmashana.
- **Bhadravasa** (when Bhadra runs), by Moon sign: Aries, Taurus, Gemini, Scorpio = Swarga; Cancer, Leo, Aquarius, Pisces = Mrityu (earth); the rest = Patala.
- **Chandra Vasa:** fiery signs E, earthy S, airy W, watery N.
- **Chandrabalam** (house of the Moon from each rashi): 1, 3, 6, 7, 10, 11 good; 2, 5, 9 "puja needed"; 4, 8, 12 bad.
- **Tarabalam:** count mod 9: Janma, Sampat, Vipat, Kshema, Pratyari, Sadhaka, Naidhana, Mitra, Paramitra.
- **Gowri Panchangam:** 8 day and 8 night parts with weekday tables (Thursday checked).
- **Samvat names:** Shaka name = (Shaka + 12) mod 60; Vikram name = (Vikram + 10) mod 60; Gujarati name = (Vikram + 9) mod 60, counting the 60 names from Prabhava = 1.
- **Pravishte:** day of the solar month (16 Nov sankranti → 26 Nov = 11).
- **Epochs:** Kali Ahargana = JD(0h) − 588465.5; Rata Die = JD − 1721424.5; Kaliyuga year = Shaka + 3179.

## Second pass (2026-11-26): the rest of the daily page, festivals, eclipses
**Method.**
- Drik's screen text was read with `uiautomator dump`. The scripts are in the session scratchpad; the raw captures are `REA/drikpanchang/days.json` and `festivals2026.json`.
- That covered 45 days (26 Nov 2026 – 9 Jan 2027, 38 complete) and the whole 2026 festival list (685 entries), all for New Delhi.
- The 38 complete days are the fixture `tools/drik/drik_days.json`, checked by `drik_days_test.dart`.

**Counting.** "Count" below means from the Sun's nakshatra to the Moon's. Drik uses the 28-nakshatra wheel (with Abhijit) for Aadal/Vidaal and Anandadi, and 27 nakshatras for the rest.

**Rules recovered:**
- **Aadal / Vidaal yoga** (28-count): mod 7 = 0 or 2 is Aadal, 3 or 6 is Vidaal.
- **Tamil yoga** is a grouping of Anandadi yoga (all 28 were seen):
  - Amrita: Amrita, Manasa, Matanga, Mitra, Siddhi, Sthira.
  - Siddha: Ananda, Chara, Chhatra, Dhata, Dhwaja, Padma, Saumya, Shrivatsa, Shubha, Vardhamana.
  - Marana: the other twelve.
- **Kumbha Chakra** (27-count):

  | Count | Part | Mark |
  |---|---|---|
  | 1 | Mouth | ✗ |
  | 2–5 | East | ✗ |
  | 6–9 | South | ✓ |
  | 10–13 | West | ✓ |
  | 14–17 | North | ✗ |
  | 18–21 | Womb | ✗ |
  | 22–24 | Bottom | ✓ |
  | 25–27 | Throat | ✓ |

  All eight marks were confirmed on screen.
- **Jeevanama** (27-count): counts 1, 2, 10, 19 and 27 are lifeless; 11–18 full life; the rest half life.
- **Netrama** (27-count): 9–20 two eyes; 5–8 and 21–24 one eye; 25–4 blind.
- **Nakshatra Shool:** Jyeshtha east, Purva Bhadrapada south, Rohini west, Uttara Phalguni north.
- **Varjyam:** Mula has a second window at ghati 56.
- **The Sun changing nakshatra mid-day:** Ravi Yoga, Homahuti, Aadal/Vidaal and the other count-based values switch with it.
- **Pravishte:** the civil day of the sankranti is day 1, even when the sankranti comes after sunset.
- **National Nirayana date:** each solar month (Mesha = Vaishakha) starts the civil day before the sankranti day, so the day number is Pravishte + 1.
- **Brihaspati samvatsara:** mean-Jupiter steps of 361.0319 days, fitted to Drik's changes at 25 Apr 2025 15:07 and 21 Apr 2026 15:53.
- **Mantri Mandala** (checked for Vikram 2082 and 2083): each office is the weekday lord at a moment.
  - Raja: Chaitra Shukla Pratipada.
  - Mantri: Mesha sankranti.
  - Sasyadhipati: Karka. Senadhipati: Simha. Dhanadhipati: Kanya. Rasadhipati: Tula. Dhanyadhipati: Dhanu. Nirasadhipati: Makara. Phaladhipati: the Meena sankranti that closes the year.
  - Meghadhipati: the Sun entering Ardra.
- **Festivals:** all 46 major North Indian festivals match Drik's 2026 dates.
  - **The day:** the one whose kala window the tithi covers most. The windows are madhyahna = the 3rd fifth of daylight, aparahna = the 4th fifth, pradosh = sunset + 2 h 24 m, nishita = the 8th night muhurta.
  - **Raksha Bandhan:** Bhadra at aparahna moves it to the next day when Purnima lasts 3 muhurtas after that sunrise.
  - **Holika Dahan:** Bhadra over the whole pradosh moves it to the next evening when Purnima lasts 3 prahar after sunrise and Pratipada is longer.
  - **Akshaya Tritiya:** the udaya tithi must last 3 muhurtas.
  - **Ganga Dussehra:** kept in the adhika Jyeshtha.
- **Eclipses** (Swiss Ephemeris; Drik's 2026 list agrees): sutak starts 12 h before a solar eclipse and 9 h before a lunar one, counted from the start of the eclipse even when the Moon rises eclipsed. For children, the old and the sick it starts at the last sunrise (solar) or sunset (lunar) before the eclipse.
- **Drik display slip:** Nishita on 6 Jan 2027 shows "12:00 PM" for 12:00 AM.

## Left out (BACKLOG)
- Panjika Yoga, Pancha Pakshi and Jain Pachchakkhan.
- The full festival database: Drik lists 685 entries for 2026 (Jain, regional, ISKCON and many minor vrats); we have 46 major ones.
- Regional calendars (Tamil, Malayalam, Bengali and others).
