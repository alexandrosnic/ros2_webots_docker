#!/bin/sh

detect_ros_ws_in_path() {
    pwd_ws="$(
        pwd | awk -F '/' '
            BEGIN {
                ws=1;
            }
            /_ws/ {
                for (i = 1; i <= NF; i++) {
                    if ($i ~ /_ws$/) {
                        ws=i;
                        break;
                    }
                }
            }
            END {
                for (i = 2; i <= ws; i++) {
                    printf "/%s", $i;
                }
            }
        '
    )"
    default_ws="${pwd_ws:-$HOME/cocobots_ws}"
}

## Print shortcut manual
shortcut_help() {
    detect_ros_ws_in_path
    default="${COLCON_PREFIX_PATH:-$default_ws/install}/.."
    dir="${1:-$default}"
    mkdir -p "$dir"
    awk '
        /^## / {
            sub(/^## +/,"",$0);
            print "\n\033[1m\033[34m" $0 "\033[0m";
        }
        /^# / {
            sub(/^# +/,"",$0);
            gsub("\\[","\033[33m[",$0);
            gsub("\\]","]\033[0m",$0);
            print $0;
        }
        /^alias/ && !/="shortcut/ {
            cmd=$0
            sub(/^.*="/,"",cmd);
            sub(/"$/,"",cmd);
            print "\033[35m" "Command: " "\033[0m" cmd "\033[0m";
        }
        /^alias / {
            sub(/=.+$/,"",$2);
            print "\033[32m" "Shortcut: " "\033[0m\033[1m" $2 "\033[0m";
        }
        /^ *eval/ {
            sub(/^ *eval "/,"",$0);
            sub(/"$/,"",$0);
            gsub("\\${","\033[36m${",$0);
            gsub("\\}","}\033[0m",$0);
            print "\033[35m" "Command: " "\033[0m" $0 "\033[0m";
        }
    ' "${dir}/src/ccbts/docker/config/shortcuts.sh"
}
alias h="shortcut_help"

## Add previous action to scratchpad
shortcut_scratchpad_add_previous() {
    scratchpad="${scratchpad}${last_action}${last_action:+;}"
    last_action=''
}
alias spa="shortcut_scratchpad_add_previous"

## Remove last action from scratchpad
shortcut_scratchpad_remove_last() {
    scratchpad="$(echo ${scratchpad} | sed 's/[^;]*;$//')"
}
alias spr="shortcut_scratchpad_remove_last"

## Clear scratchpad
shortcut_scratchpad_clear() {
    scratchpad=''
}
alias spclr="shortcut_scratchpad_clear"


## Build current directory using colcon
# Arguments:
#   - working directory [optional]
shortcut_colcon_workspace_build() {
    detect_ros_ws_in_path
    dir="${1:-$default_ws}"
    mkdir -p "$dir"
    eval "cd ${dir} && colcon build --symlink-install"
}
alias cb="shortcut_colcon_workspace_build"

## Remove existing build files
# Arguments:
#   - workspace directory [optional]
shortcut_remove_ros_workspace_build() {
    detect_ros_ws_in_path
    default="${COLCON_PREFIX_PATH:-$default_ws/install}/.."
    dir="${1:-$default}"
    mkdir -p "$dir"
    eval "rm -rf ${dir}/build/ ${dir}/install/"
}
alias rr="shortcut_remove_ros_workspace_build"

## Source current ROS2 workspace
# Arguments:
#   - workspace directory [optional]
shortcut_source_ros_workspace() {
    detect_ros_ws_in_path
    default="${COLCON_PREFIX_PATH:-$default_ws/install}/.."
    dir="${1:-$default}"
    mkdir -p "$dir"
    eval "source ${dir}/install/local_setup.bash"
}
alias s="shortcut_source_ros_workspace"

