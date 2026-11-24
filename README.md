# Astro app (working name)

Android workbench for a professional Vedic astrologer. Plan: `../astrosage/BUILD_PLAN.md`. Teardown: `../astrosage/ASTROSAGE_TEARDOWN.md`.

```
packages/jyotish_core/   calculation engine (pure Dart + Swiss Ephemeris via the sweph plugin)
app/                     Flutter Android app
tools/golden/            golden charts from reference programs (JSON)
tools/build_sweph_dll.bat  builds native/sweph.dll so engine tests run on Windows
DIVERGENCES.md           where and why our numbers differ from other software
```

## Running the engine tests (PC)

1. `cd packages/jyotish_core && flutter pub get`
2. Once: `tools\build_sweph_dll.bat` (needs Visual Studio 2022 C++ tools)
3. `flutter test`

## Running the app

`cd app && flutter run` with the phone connected (USB debugging).

## Licence note

Swiss Ephemeris is AGPL-3.0 (or the paid Swiss Ephemeris Professional License). Fine for a private tool if the source goes with the APK. Before any public or paid release: buy the Professional License or replace `SwephEphemeris` behind the `Ephemeris` interface.
