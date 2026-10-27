#!/usr/bin/env bash
# One-off admin steps from docs/mac-workflow-plan.md (phase 1). Run: sudo bash <this file>
set -uo pipefail
[ "$(id -u)" -eq 0 ] || { echo "run with sudo"; exit 1; }

# Adobe leftovers (Acrobat was removed 2026-10-26; these launchd jobs and support files were orphaned)
launchctl bootout system /Library/LaunchDaemons/com.adobe.agsservice.plist 2>/dev/null
launchctl bootout "gui/$(stat -f %u /dev/console)" /Library/LaunchAgents/com.adobe.GC.Invoker-1.0.plist 2>/dev/null
for p in /Library/LaunchDaemons/com.adobe.agsservice.plist \
         /Library/LaunchAgents/com.adobe.GC.Invoker-1.0.plist \
         "/Library/Application Support/Adobe"; do
  [ -e "$p" ] && trash "$p" && echo "trashed $p"
done

# Display sleep: 10 min on battery, 30 min on power (was 180)
pmset -b displaysleep 10
pmset -c displaysleep 30
pmset -g custom | grep -E "^(Battery|AC)|displaysleep"
