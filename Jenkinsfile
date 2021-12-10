// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License

pipeline {
    agent {
        kubernetes {
            yaml """
kind: Pod
metadata:
  name: default
spec:
  containers:
  - name: jnlp
    image: gudari/jenkins-agent:4.9-ranger-arm64
    imagePullPolicy: Always
    resources:
      limits:
        memory: "2048Mi"
        cpu: "1000m"
      requests:
        memory: "2048Mi"
        cpu: "1000m"
"""
        }
    }
    options {
        ansiColor('xterm')
    }
    environment {
        GITHUB_ORGANIZATION = 'gudari'
        GITHUB_REPO         = 'atlas'
        VERSION             = '2.2.0'
        GITHUB_TOKEN        = credentials('github_token')
    }
    stages {
        stage('Build') {
            steps {
                sh ("mvn clean -DskipTests package -Pdist,embedded-hbase-solr")
                sh ("./create_release.sh $GITHUB_ORGANIZATION $GITHUB_REPO $VERSION $GITHUB_TOKEN")
            }
        }
    }
}
