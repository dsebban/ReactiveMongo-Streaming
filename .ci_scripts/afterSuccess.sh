#! /usr/bin/env bash

set -e

SCRIPT_DIR=`dirname $0`

if [[ "$CI_CATEGORY" != "UNIT_TESTS" ]]; then
  killall -9 mongod 2>&1 || true
fi

rm -rf "$HOME/.ivy2/cache/org.reactivemongo/"

if [[ "$CI_BRANCH" != "master" || "x$PUBLISHABLE" != "xyes" || \
      "x$SONATYPE_USER" = "x" || "x$SONATYPE_PASS" = "x" ]]; then

    U=`echo "$SONATYPE_USER" | sed -e 's/./X/g'`
    P=`echo "$SONATYPE_PASS" | sed -e 's/./X/g'`

    echo -e -n "\nINFO: Skip the snapshot publication (${CI_BRANCH}, $PUBLISHABLE ${U}:${P})\n"

    exit 0
fi

cd "$SCRIPT_DIR/.."

export PUBLISH_REPO_NAME="Sonatype Nexus Repository Manager"
export PUBLISH_REPO_URL="https://oss.sonatype.org/content/repositories/snapshots"
export PUBLISH_REPO_ID="oss.sonatype.org"
export PUBLISH_USER="$SONATYPE_USER"
export PUBLISH_PASS="$SONATYPE_PASS"

sbt '+publish'
