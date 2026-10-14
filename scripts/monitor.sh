#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <service-name>" >&2
    echo "Example: $0 docker" >&2
    exit 1
fi

SERVICE="$1"

if ! systemctl list-unit-files --type=service --no-pager --no-legend \
        | awk '{print $1}' | grep -qx "${SERVICE}.service"; then
    echo "Error: service '${SERVICE}' not found" >&2
    exit 2
fi

echo "=================================================="
echo " Monitoring service: ${SERVICE}"
echo "=================================================="

STATUS=$(systemctl is-active "${SERVICE}" || true)
echo "Status: ${STATUS}"

if [[ "${STATUS}" != "active" ]]; then
    echo ""
    echo "---- Last 10 log lines for ${SERVICE} ----"
    journalctl -u "${SERVICE}" -n 10 --no-pager || true
fi

echo ""
echo "---- Errors in /var/log/syslog (last hour) ----"

if [[ -r /var/log/syslog ]]; then
    # Получаем время "час назад" в формате, как в syslog: "Oct 14 18:"
    ONE_HOUR_AGO=$(date -d '1 hour ago' '+%b %e %H')

    ERRORS=$(grep -i "error\|fail\|critical" /var/log/syslog \
        | awk -v since="${ONE_HOUR_AGO}" '
            {
                # syslog формат: Oct 14 18:23:45 hostname process: message
                log_time = $1 " " $2 " " substr($3, 1, 2)
                if (log_time >= since) {
                    count++
                }
            }
            END { print count+0 }
        ')

    echo "Errors found: ${ERRORS}"
else
    echo "Warning: /var/log/syslog not readable (need root?)"
fi

echo ""
echo "=================================================="
