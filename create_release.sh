#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

GITHUB_ORGANIZATION=$1
GITHUB_REPO=$2
VERSION=$3
GITHUB_TOKEN=$4
ARCH=${5:-"amd64"}

RELEASE_NAME="release-${VERSION}-${ARCH}"

release=$(curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
    --data "{\"tag_name\": \"$RELEASE_NAME\", \"target_commitish\": \"$RELEASE_NAME\", \"name\": \"$RELEASE_NAME\", \"draft\": false }" \
    https://api.github.com/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases)

id=$(echo "$release" | sed -n -e 's/"id":\ \([0-9]\+\),/\1/p' | head -n 1 | sed 's/[[:blank:]]//g')

files=( \
    apache-atlas-$VERSION-atlas-index-repair.zip \
    apache-atlas-$VERSION-classification-updater.zip \
    apache-atlas-$VERSION-falcon-hook.tar.gz \
    apache-atlas-$VERSION-hbase-hook.tar.gz \
    apache-atlas-$VERSION-hive-hook.tar.gz \
    apache-atlas-$VERSION-impala-hook.tar.gz \
    apache-atlas-$VERSION-kafka-hook.tar.gz \
    apache-atlas-$VERSION-server.tar.gz \
    apache-atlas-$VERSION-sqoop-hook.tar.gz \
    apache-atlas-$VERSION-storm-hook.tar.gz \
)

for file in "${files[@]}"
do
    curl -XPOST -H "Authorization:token $GITHUB_TOKEN" \
        -H "Content-Type:application/octet-stream" \
        --data-binary @distro/target/$file https://uploads.github.com/repos/$GITHUB_ORGANIZATION/$GITHUB_REPO/releases/$id/assets?name=$file
done
