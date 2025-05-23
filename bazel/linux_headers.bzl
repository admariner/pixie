# Copyright 2018- The Pixie Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

# Linux headers are bundled in PEM image for PEM to setup the BPF runtime.
def linux_headers():
    http_file(
        name = "timeconst_bc",
        urls = ["https://storage.googleapis.com/pixie-dev-public/timeconst_v4.20.bc"],
        sha256 = "99bc07f850094c7fa78eff91867841957fab8080400a17f1b70ca5544c0d1b51",
        downloaded_file_path = "timeconst.bc",
    )

    http_file(
        name = "linux_headers_merged_x86_64_tar_gz",
        urls = [
            "https://github.com/pixie-io/dev-artifacts/releases/download/linux-headers%2Fpl7/linux-headers-merged-x86_64-pl7.tar.gz",
            "https://storage.googleapis.com/pixie-dev-public/linux-headers/pl7/linux-headers-merged-x86_64-pl7.tar.gz",
        ],
        sha256 = "e4635db60d7f4139a8fea1b0490a0d0159e1edb9f3272ba2bcf40f8ea933bf93",
        downloaded_file_path = "linux-headers-merged-x86_64.tar.gz",
    )
    http_file(
        name = "linux_headers_merged_arm64_tar_gz",
        urls = [
            "https://github.com/pixie-io/dev-artifacts/releases/download/linux-headers%2Fpl7/linux-headers-merged-arm64-pl7.tar.gz",
            "https://storage.googleapis.com/pixie-dev-public/linux-headers/pl7/linux-headers-merged-arm64-pl7.tar.gz",
        ],
        sha256 = "c2a99ad6462dd1211c4e2f54f7279b7cf526e73918148350ccba988b95ca6115",
        downloaded_file_path = "linux-headers-merged-arm64.tar.gz",
    )

def gen_timeconst_file(name, const):
    native.genrule(
        name = "timeconst_%d" % const,
        srcs = ["@timeconst_bc//file"],
        outs = ["timeconst_%d.h" % const],
        cmd = "echo %d | bc $< > $(@D)/timeconst_%d.h" % (const, const),
    )

def gen_timeconst(name):
    hzs = [100, 250, 300, 1000]
    for hz in hzs:
        gen_timeconst_file("timeconst_%d" % hz, hz)

    srcs = ["timeconst_%d" % hz for hz in hzs]
    native.filegroup(
        name = name,
        srcs = srcs,
    )
