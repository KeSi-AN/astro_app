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

## Left out (BACKLOG)
- Aadal and Vidaal yoga, Tamil yoga, Jeevanama/Netrama and Kumbha Chakra. These use per-nakshatra tables that six days of data don't fill in.
- Brihaspati samvatsara, Mantri Mandala and National Nirayana date.
- Panjika Yoga, Pancha Pakshi, Jain Pachchakkhan, the festival database, eclipses and regional calendars.
