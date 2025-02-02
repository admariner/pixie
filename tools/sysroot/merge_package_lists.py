#!/usr/bin/env python

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
#
# Borrowed from Chromium:
# Copyright 2016 The Chromium Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

"""Merge package entries from different package lists.
"""

# This is used for replacing packages in eg. bullseye with those in bookworm.
# The updated packages are ABI compatible, but include security patches, so we
# should use those instead in our sysroots.

import sys

if len(sys.argv) != 2:
    exit(1)

packages = {}


def AddPackagesFromFile(file):
    global packages
    lines = file.readlines()
    if len(lines) % 3 != 0:
        exit(1)
    for i in range(0, len(lines), 3):
        packages[lines[i]] = (lines[i + 1], lines[i + 2])


AddPackagesFromFile(open(sys.argv[1], 'r'))
AddPackagesFromFile(sys.stdin)

output_file = open(sys.argv[1], 'w')

for (package, (filename, sha256)) in packages.items():
    output_file.write(package + filename + sha256)
