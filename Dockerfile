# Copyright (c) 2020-present, The kubequery authors
#
# This source code is licensed as defined by the LICENSE file found in the
# root directory of this source tree.
#
# SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)

FROM ubuntu:20.04

ARG OSQUERY_VERSION=4.6.0
ARG KUBEQUERY_VERSION

LABEL \
  name="kubequery" \
  description="kubequery powered by Osquery" \
  version="${KUBEQUERY_VERSION}" \
  url="https://github.com/Uptycs/kubequery"

ADD https://pkg.osquery.io/deb/osquery_${OSQUERY_VERSION}-1.linux_amd64.deb /tmp/osquery.deb
ADD kubequery /usr/bin/kubequery

RUN set -ex; \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    chmod 700 /usr/bin/kubequery && \
    dpkg -i /tmp/osquery.deb && \
    /etc/init.d/osqueryd stop && \
    rm -rf /var/osquery/* /var/log/osquery/* /var/lib/apt/lists/* /var/cache/apt/* /tmp/* && \
    groupadd -g 1000 kubequery && \
    useradd -m -g kubequery -u 1000 -d /opt/kubequery -s /bin/bash kubequery && \
    mkdir /opt/kubequery/logs && \
    chown kubequery:kubequery /usr/bin/osquery? /usr/bin/kubequery /opt/kubequery/logs

# NOTE: Not running as root breaks bunch of Osquery tables. But Osquery tables are meaningless
#       in the context of kubequery as the pod is ephemeral in nature
USER kubequery

WORKDIR /opt/kubequery

ENTRYPOINT ["/usr/bin/osqueryd", \
                "--flagfile=/opt/kubequery/etc/osquery.flags", \
                "--config_path=/opt/kubequery/etc/osquery.conf", \
                "--database_path=/opt/kubequery/osquery.db", \
                "--pidfile=/opt/kubequery/osqueryd.pid", \
                "--logger_path=/opt/kubequery/logs", \
                "--extension=/usr/bin/kubequery", \
                "--extensions_socket=/opt/kubequery/osquery.em" \
           ]
