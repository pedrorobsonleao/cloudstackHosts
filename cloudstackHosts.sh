#!/bin/bash

PROG=${0};

SRC="${HOME}/.cloudhosts";
TARGET="hosts";

function get() {
    [ ${USER} != 'root' ] && {
        cd lib;
        [ ! -d node_modules ] && {
            npm install;
        } 
        node run.js | sort -k 3 | egrep -v  ^$ >${SRC}.tmp && {
            mv ${SRC}.tmp ${SRC};
        }
        cd ${OLDPWD};
    } || true;
    
}

function sync() {
    local tmpfile="/tmp/.$$.hosts";

    [ -f ${SRC} ] && {
        sed -n '/#cloudhosts start/{/#cloudhosts start/tc;:a;/#cloudhosts end/!{N;ba;};:c;s/.*#cloudhosts start//;s/#cloudhosts end.*$//;p;}' /etc/${TARGET} | grep -v ^$ >${tmpfile};
        #--ignore-all-space
        diff --ignore-all-space ${SRC} ${tmpfile} >/dev/null || {
            # has changes
            cp /etc/${TARGET} ~/.${TARGET}.old;
            cat ~/.${TARGET}.old | \
            awk 'BEGIN { p=1} /^#cloudhosts start/ { print; p=0; } /^#cloudhosts end/ { p=1; } p { print }' >/tmp/${TARGET}.new;

            tac ${SRC} | while read line; do
                sed -e "/#cloudhosts start/{p;s/.*/${line}/;}" -i /tmp/${TARGET}.new;
            done
            [ ${USER} == 'root' ] && {
                cp -v /tmp/${TARGET}.new /etc/${TARGET};
                echo "backup file in ${HOME}/.${TARGET}.old";
            } || {
                cat /tmp/${TARGET}.new
            };

            rm -f ${tmpfile} /tmp/${TARGET}.new;
        }
    }
}

function help() {
    echo "Use: ${PROG} [command ...]";
    echo;
    echo "     commands";
    echo "     help - show this help";
    echo "     get  - get a cloudstack hosts list - ~/.coudhosts";
    echo "     sync - merge cloudstack hosts in hosts file - use sudo to sync";
    echo "     show - show hosts in cache";
}

function show() {
    [ ! -f ${SRC} ] && get;
    cat  ${SRC};
}

function main() {
    local cmd=;
    local cmdLst=${@};

    [ ${#@} == 0 ] && {
        cmdLst="get sync";
    }

    for cmd in ${cmdLst}; do
        cmd=${cmd//--/};
        grep -q "function ${cmd,,}\(\)" ${PROG} && {
            ${cmd,,};
        } || {
            echo "${cmd} - invalid command!";
        };
    done
}

main ${@};
