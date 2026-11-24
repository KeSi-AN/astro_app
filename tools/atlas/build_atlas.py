"""Build the offline place atlas (app/assets/atlas/atlas.sqlite) from GeoNames.

Data: GeoNames (https://www.geonames.org), CC BY 4.0. Credit it in the app's
About screen.

Inputs (download into tools/atlas/raw/, git-ignored):
  IN.zip -> IN.txt          all Indian features (towns and villages)
  cities500.zip -> cities500.txt   world places with population >= 500
  admin1CodesASCII.txt, admin2Codes.txt, countryInfo.txt

Run:  python -I tools/atlas/build_atlas.py
"""
import os
import sqlite3
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RAW = os.path.join(HERE, "raw")
OUT = os.path.join(HERE, "..", "..", "app", "assets", "atlas", "atlas.sqlite")

# Populated-place feature codes kept for India (PPLQ = abandoned, PPLX = city
# sections, PPLH = historical are left out).
INDIA_CODES = {"PPL", "PPLA", "PPLA2", "PPLA3", "PPLA4", "PPLC", "PPLL",
               "PPLF", "PPLR", "PPLS", "PPLG"}
WORLD_MIN_POP = 1000


def read_codes(fname):
    codes = {}
    with open(os.path.join(RAW, fname), encoding="utf-8") as f:
        for line in f:
            if line.startswith("#"):
                continue
            p = line.rstrip("\n").split("\t")
            codes[p[0]] = p[2] if len(p) > 2 and p[2] else p[1]
    return codes


def read_countries():
    names = {}
    with open(os.path.join(RAW, "countryInfo.txt"), encoding="utf-8") as f:
        for line in f:
            if line.startswith("#"):
                continue
            p = line.rstrip("\n").split("\t")
            names[p[0]] = p[4]
    return names


def rows(fname):
    with open(os.path.join(RAW, fname), encoding="utf-8") as f:
        for line in f:
            p = line.rstrip("\n").split("\t")
            yield {
                "id": int(p[0]), "name": p[1], "ascii": p[2] or p[1],
                "lat": float(p[4]), "lon": float(p[5]),
                "fclass": p[6], "fcode": p[7], "cc": p[8],
                "a1": p[10], "a2": p[11],
                "pop": int(p[14] or 0), "tz": p[17],
            }


def main():
    admin1 = read_codes("admin1CodesASCII.txt")
    admin2 = read_codes("admin2Codes.txt")
    countries = read_countries()

    places = []
    seen = set()  # (name, admin, ~2 km cell) to drop duplicates
    admins, tzs = {}, {}

    def add(r):
        if not r["tz"]:
            return
        name = " ".join(r["ascii"].split())
        if not name:
            return
        a1 = admin1.get(f'{r["cc"]}.{r["a1"]}', "")
        a2 = admin2.get(f'{r["cc"]}.{r["a1"]}.{r["a2"]}', "")
        admin = admins.setdefault((a2, a1, r["cc"]), len(admins) + 1)
        tz = tzs.setdefault(r["tz"], len(tzs) + 1)
        lat, lon = round(r["lat"] * 1e4), round(r["lon"] * 1e4)
        dup = (name.lower(), admin, lat // 200, lon // 200)
        if dup in seen:
            return
        seen.add(dup)
        places.append((name, r["id"], admin, lat, lon, tz, r["pop"]))

    for r in rows("IN.txt"):
        if r["fclass"] == "P" and r["fcode"] in INDIA_CODES:
            add(r)
    india = len(places)
    for r in rows("cities500.txt"):
        if r["cc"] != "IN" and r["pop"] >= WORLD_MIN_POP:
            add(r)

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    if os.path.exists(OUT):
        os.remove(OUT)
    db = sqlite3.connect(OUT)
    db.executescript("""
        PRAGMA page_size = 4096;
        CREATE TABLE country(code TEXT PRIMARY KEY, name TEXT NOT NULL);
        CREATE TABLE admin(id INTEGER PRIMARY KEY, admin2 TEXT NOT NULL,
                           admin1 TEXT NOT NULL, country TEXT NOT NULL);
        CREATE TABLE tz(id INTEGER PRIMARY KEY, name TEXT NOT NULL);
        -- lat/lon are degrees x 10^4 (about 11 m resolution).
        CREATE TABLE place(
          name TEXT NOT NULL COLLATE NOCASE,
          id INTEGER NOT NULL,
          admin INTEGER NOT NULL,
          lat INTEGER NOT NULL,
          lon INTEGER NOT NULL,
          tz INTEGER NOT NULL,
          pop INTEGER NOT NULL,
          PRIMARY KEY(name, id)
        ) WITHOUT ROWID;
        CREATE TABLE meta(k TEXT PRIMARY KEY, v TEXT);
    """)
    db.executemany("INSERT INTO country VALUES (?,?)", countries.items())
    db.executemany("INSERT INTO admin VALUES (?,?,?,?)",
                   ((i, *k) for k, i in admins.items()))
    db.executemany("INSERT INTO tz VALUES (?,?)", ((i, k) for k, i in tzs.items()))
    db.executemany("INSERT INTO place VALUES (?,?,?,?,?,?,?)", places)
    db.executemany("INSERT INTO meta VALUES (?,?)", [
        ("source", "GeoNames geonames.org, CC BY 4.0"),
        ("schema", "1"),
        ("india_places", str(india)),
        ("total_places", str(len(places))),
    ])
    db.commit()
    db.execute("VACUUM")
    db.close()
    size = os.path.getsize(OUT) / 1e6
    print(f"India {india}, total {len(places)}, {size:.1f} MB -> {OUT}")


if __name__ == "__main__":
    sys.exit(main())
