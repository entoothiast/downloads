# Entoothiast downloads

Ready-to-run builds of Entoothiast apps. Pick your app below, open its latest release, and download
the file for your computer.

| App | What it is | Downloads |
|---|---|---|
| **WattTest** | Lactate threshold test monitor for the Wattbike AtomX (macOS, Windows) | [Releases](https://github.com/entoothiast/downloads/releases?q=watttest&expanded=true) |
| **LacTracker** | Records iTooth lactate-sensor sessions over Bluetooth and exports them to `_data` (macOS, Windows) | [Releases](https://github.com/entoothiast/downloads/releases?q=lactracker&expanded=true) |

Each app's current version is in `<app>/latest.json`; the apps read it to remind you when an
update is available.

---

## For maintainers

The source of each app stays in its own private repository. Its CI builds the files and calls
the reusable workflow [`.github/workflows/publish.yml`](.github/workflows/publish.yml), which
creates a release here tagged `<app>-v<version>` and updates `<app>/latest.json`. Usage is
documented at the top of that file.

**Token:** callers pass a secret named `RELEASES_TOKEN`: a fine-grained token with
*Contents: Read and write* on this repository only. Store it as a **repository secret in each
app's repo** (Settings → Secrets and variables → Actions). Organisation secrets would avoid the
repetition, but on GitHub Free they are not available to private repositories. When the token is
renewed, update it in every app repo.

**Adding an app:**
1. In the app's CI, add a job that calls `entoothiast/downloads/.github/workflows/publish.yml@main`
   with its `app` name, version, notes, artifact pattern and file names.
2. Add the `RELEASES_TOKEN` repository secret to the app's repo (same token as the other apps).
3. Point the app's update check at
   `https://raw.githubusercontent.com/entoothiast/downloads/main/<app>/latest.json`
   and add a row to the table above.

Don't protect `main` here: the workflow commits `latest.json` to it.
