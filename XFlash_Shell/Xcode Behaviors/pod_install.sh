#!/bin/sh
path=""
if [ -n "$XcodeProjectPath" ]; then
    path=$XcodeProjectPath
else
    path=$XcodeWorkspacePath
fi
# 执行 AppleScript 打开 Terminal 进行 podinstall
osascript <<EOF
    tell application "Iterm"
        activate
        do script with command "cd \"$path\"/..;pod install"
    end tell
EOF
