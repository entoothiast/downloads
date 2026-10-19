# Entoothiast downloads

Ready-to-run builds of Entoothiast apps. Pick your app below, open its latest release, and download
the file for your computer.

| App | What it is | Downloads |
|---|---|---|
| **WattTest** | Lactate threshold test monitor for the Wattbike AtomX (macOS, Windows) | [Releases](https://github.com/entoothiast/downloads/releases?q=watttest&expanded=true) |

Each app's current version is in `<app>/latest.json`; the apps read it to remind you when an
update is available.

---

## For maintainers

The source of each app stays in its own private repository. Its CI builds the files and calls
the reusable workflow [`.github/workflows/publish.yml`](.github/workflows/publish.yml), which
creates a release here tagged `<app>-v<version>` and updates `<app>/latest.json`. Usage is
documented at the top of that file.

**Token:** callers pass an organisation secret `RELEASES_TOKEN`: a fine-grained token with
*Contents: Read and write* on this repository only.

**Adding an app:**
1. In the app's CI, add a job that calls `entoothiast/downloads/.github/workflows/publish.yml@main`
   with its `app` name, version, notes, artifact pattern and file names.
2. Give the app's repository access to the `RELEASES_TOKEN` organisation secret.
3. Point the app's update check at
   `https://raw.githubusercontent.com/entoothiast/downloads/main/<app>/latest.json`
   and add a row to the table above.

Don't protect `main` here: the workflow commits `latest.json` to it.
