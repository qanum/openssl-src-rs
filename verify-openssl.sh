#!/usr/bin/env bash
# verify-openssl.sh: check that openssl/ is the official OpenSSL release.
#
# Downloads the release tarball named below, checks its SHA-256 against the
# value published by the OpenSSL project, and compares every file under
# openssl/ with the file of the same path in the tarball. Any difference,
# or a file under openssl/ that the tarball does not have, is an error.
# Files of the tarball that are left out here (tests, docs, demos) are the
# ones the upstream openssl-src crate also leaves out.
#
# Usage: ./verify-openssl.sh
set -euo pipefail

VERSION="3.5.9"
SHA256="603f5602e2eef00d77fbd429d34dcd5822bb301757a1bc9cdb24c670f1eb859a"
URL="https://github.com/openssl/openssl/releases/download/openssl-${VERSION}/openssl-${VERSION}.tar.gz"

here=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl -sSfL "$URL" -o "$tmp/openssl.tar.gz"
echo "${SHA256}  $tmp/openssl.tar.gz" | sha256sum -c --quiet
tar xzf "$tmp/openssl.tar.gz" -C "$tmp"
ref="$tmp/openssl-${VERSION}"

n=0
while IFS= read -r -d '' f; do
    rel=${f#"$here/openssl/"}
    if [ ! -f "$ref/$rel" ]; then
        echo "verify-openssl: not in the release tarball: openssl/$rel" >&2
        exit 1
    fi
    if ! cmp -s "$f" "$ref/$rel"; then
        echo "verify-openssl: differs from the release tarball: openssl/$rel" >&2
        exit 1
    fi
    n=$((n + 1))
done < <(find "$here/openssl" -type f -print0)

[ "$n" -gt 1000 ] || { echo "verify-openssl: only $n files found" >&2; exit 1; }
echo "verify-openssl: OK, $n files under openssl/ match openssl-${VERSION}.tar.gz (sha256 ${SHA256})"
