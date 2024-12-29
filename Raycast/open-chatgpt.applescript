#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title openChatGptChromeTab
# @raycast.mode fullOutput
#
# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Raycast Scripts

tell application "Google Chrome"
    set targetURLPrefix to "https://chatgpt.com"
    set foundTab to false
    repeat with aWindow in windows
        set tabIndex to 0
        repeat with aTab in (tabs of aWindow)
            set tabIndex to tabIndex + 1
            set tabURL to URL of aTab
            if tabURL starts with targetURLPrefix then
                set foundTab to true
                set active tab index of aWindow to tabIndex
                tell aWindow to set index to 1
                exit repeat
            end if
        end repeat
        if foundTab then exit repeat
    end repeat
    if not foundTab then
        tell front window to make new tab with properties {URL:targetURLPrefix}
    end if
    activate
end tell
