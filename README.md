# Entoothiast downloads

Internal update files for Entoothiast apps. This repository is public only so the apps can check
for updates without a login; it is not a download page and is not meant for use outside
Entoothiast.

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
   `https://raw.githubusercontent.com/entoothiast/downloads/main/<app>/latest.json`.
   Link users to the releases from the app's private repo or internal docs, not from here.

**Without CI:** LacBench is built and published from a Mac (`scripts/publish.sh` in its repo),
which makes the same `<app>-v<version>` release and `<app>/latest.json` with the maintainer's own
`gh` login instead of a token. Until EmStat Control 0.1.0 is gone, LacBench releases are also
published under `emstat-control`, so that version's update reminder points to LacBench.

Don't protect `main` here: publishing commits `latest.json` to it.
