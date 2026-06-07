#!/bin/sh

# SPDX-FileCopyrightText: Copyright 2025-2026 The Secureblue Authors
#
# SPDX-License-Identifier: Apache-2.0

# Package dependencies for this script:
# git-core go2rpm go-vendor-tools python3-specfile rpmautospec rpmdevtools

set -eux

VERSION=$(awk '/^Version:[[:blank:]]/ { print $2; exit }' slsa-verifier/slsa-verifier.spec)
(
    cd slsa-verifier
    cp go-vendor-tools.toml ..
    rpmautospec process-distgit ./slsa-verifier.spec ../slsa-verifier.spec
)
mkdir -p generate_vendor
cp go-vendor-tools.toml generate_vendor
(
    cd generate_vendor
    go2rpm --name slsa-verifier --profile vendor --version "${VERSION}" -s cli/slsa-verifier https://github.com/slsa-framework/slsa-verifier
    mv "slsa-verifier-${VERSION}.tar.gz" "slsa-verifier-${VERSION}-vendor.tar.bz2" ..
)
rm -rf slsa-verifier generate_vendor
