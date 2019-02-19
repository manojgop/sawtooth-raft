# Copyright 2018 Intel Corporation
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

FROM ubuntu:bionic

RUN apt-get update \
 && apt-get install gnupg -y

RUN \
 if [ ! -z $HTTP_PROXY ] && [ -z $http_proxy ]; then \
   http_proxy=$HTTP_PROXY; \
 fi; \
 if [ ! -z $http_proxy ]; then \
   key_server_options="--keyserver-options http-proxy=${http_proxy}"; \
 fi; \
 echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/nightly bionic universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 ${key_server_options} --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 ${key_server_options} --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install -y -q --allow-downgrades \
    curl \
    inetutils-ping \
    net-tools \
    python3-sawtooth-cli \
    python3-sawtooth-settings \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
