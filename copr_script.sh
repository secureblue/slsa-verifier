#!/bin/sh

# SPDX-FileCopyrightText: Copyright 2025-2026 The Secureblue Authors
#
# SPDX-License-Identifier: Apache-2.0

# Package dependencies for this script:
# git-core go2rpm go-vendor-tools python3-specfile rpmautospec rpmdevtools

set -eux

build_dir=$(pwd)
version=$(awk '$1 == "Version:" { print $2; exit }' slsa-verifier/slsa-verifier.spec)
(
    cd slsa-verifier
    cp go-vendor-tools.toml "${build_dir}"
    rpmautospec process-distgit slsa-verifier.spec "${build_dir}/slsa-verifier.spec"
)
mkdir -p generate_vendor
cp go-vendor-tools.toml generate_vendor
(
    cd generate_vendor
    go2rpm --name slsa-verifier --profile vendor --version "${version}" https://github.com/slsa-framework/verifier
    mv "verifier-${version}.tar.gz" "verifier-${version}-vendor.tar.bz2" "${build_dir}"
)
rm -rf slsa-verifier generate_vendor
