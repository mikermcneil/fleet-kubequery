#!/bin/sh

UUID=$(/opt/uptycs/bin/uuidgen)
if [ $? -eq 0 ]; then
    # Use kube-system UUID as the host identifier
    ADDITIONAL_FLAGS="--host_identifier=specified --specified_identifier=${UUID}"
fi

if [ -d /opt/uptycs/config ]; then
  # Copy bootstrap flags and configuration from volume mount
  cp /opt/uptycs/config/* /opt/uptycs/etc/
fi

exec /opt/uptycs/bin/basequery \
    --flagfile=/opt/uptycs/etc/kubequery.flags \
    --config_path=/opt/uptycs/etc/kubequery.conf \
    ${ADDITIONAL_FLAGS} \
    --pidfile=/opt/uptycs/var/kubequery.pid \
    --database_path=/opt/uptycs/kubequery.db \
    --logger_path=/opt/uptycs/logs \
    --enroll_tables=osquery_info,kubernetes_info \
    --extensions_socket=/opt/uptycs/var/kubequery.em \
    --extensions_autoload=/opt/uptycs/etc/autoload.exts \
    --extensions_require=kubequery \
    --extension_event_tables=kubernetes_events \
    --tls_user_agent=kubequery/${KUBEQUERY_VERSION} \
    --watchdog_level=-1 \
    -D
