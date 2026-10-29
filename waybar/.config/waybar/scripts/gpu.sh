#!/usr/bin/env bash
# Waybar GPU module: nvidia-smi stats as JSON

set -euo pipefail

if ! command -v nvidia-smi >/dev/null 2>&1; then
    echo '{"text":"N/A ", "tooltip":"nvidia-smi not found", "class":"error"}'
    exit 0
fi

IFS=',' read -r util mem_used mem_total temp <<< "$(
    nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu \
        --format=csv,noheader,nounits
)"

util=$(echo "$util" | tr -d ' ')
mem_used=$(echo "$mem_used" | tr -d ' ')
mem_total=$(echo "$mem_total" | tr -d ' ')
temp=$(echo "$temp" | tr -d ' ')

class="normal"
if (( temp >= 80 )); then
    class="critical"
elif (( temp >= 65 )); then
    class="warning"
fi

text="${util}%  ${mem_used}MiB 󰢮"
tooltip="GPU: ${util}%\nTemp: ${temp}°C\nVRAM: ${mem_used} / ${mem_total} MiB"

printf '{"text": "%s", "tooltip": "%s", "class": "%s", "percentage": %s}\n' \
    "$text" "$tooltip" "$class" "$util"
