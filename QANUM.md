# Qanum branch of openssl-src

This branch builds **OpenSSL 3.5 LTS** (supported upstream until 2030-04-08)
for Qanum. Upstream `openssl-src` follows the newest OpenSSL release only and
its 3.5 series stopped at 3.5.5, so Qanum keeps this branch to stay on the
LTS line with every patch release.

Source: upstream https://github.com/alexcrichton/openssl-src-rs, tag
`300.5.5+3.5.5` (commit `82360627527a85feefe41e2c1f2b2911c16c3109`), by Alex
Crichton and contributors. This repository starts from a single commit
without the upstream history: an old upstream commit (the 2017 import of
OpenSSL 1.1.0f) carries a public OpenSSL test key that GitHub push
protection blocks. To review this branch, compare it with that tag.

Differences from upstream tag `300.5.5+3.5.5`:

- `openssl/` holds the files of the official release tarball
  `openssl-3.5.9.tar.gz` as plain files instead of a git submodule, so a
  cargo git dependency does not have to fetch the whole OpenSSL history.
  Only the files that upstream `openssl-src` packages are kept (its
  `exclude` list in `Cargo.toml`); tests, docs and demos are left out.
- The crate version is `300.5.9+3.5.9`.
- `verify-openssl.sh` checks the files against the official tarball and its
  published SHA-256. Run it after every update.

The build logic in `src/` is upstream's, unchanged. Licences are upstream's:
the crate is MIT or Apache-2.0, OpenSSL is Apache-2.0 (`openssl/LICENSE.txt`).

## Updating to a new 3.5.x release

1. Replace `openssl/` with the files of the new tarball, keeping the same set
   of paths (add or drop files only where the release did).
2. Update `VERSION` and `SHA256` in `verify-openssl.sh` from the release
   announcement, and the crate version in `Cargo.toml`.
3. Run `./verify-openssl.sh`, then build and test Qanum against the branch
   before moving the pinned commit there.
