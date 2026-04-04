#!/usr/bin/env bash
set -e

MESSAGE="${1:-Claude Code needs your attention}"
TITLE="${2:-Claude Code}"

if [[ "$(uname -s)" == "Darwin" ]]; then
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
elif grep -qi microsoft /proc/version 2>/dev/null; then
    powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; \$n = New-Object System.Windows.Forms.NotifyIcon; \$n.Icon = [System.Drawing.SystemIcons]::Information; \$n.BalloonTipTitle = '$TITLE'; \$n.BalloonTipText = '$MESSAGE'; \$n.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info; \$n.Text = '$TITLE'; \$n.Visible = \$true; \$n.ShowBalloonTip(5000); Start-Sleep -Seconds 2; \$n.Dispose()"
fi
