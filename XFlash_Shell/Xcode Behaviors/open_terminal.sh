#!/bin/sh
if [ -n "$XcodeProjectPath" ]; then
open -a Iterm "$XcodeProjectPath"/..
else
open -a Iterm "$XcodeWorkspacePath"/..
fi
