#!/usr/bin/env bash

# Install Git and Golang toolchain

function gdir_env_install_pkgs
{
    if [ -x "$(command -v xcode-select)" ]; then
        xcode-select --install
    fi

    cmd=()
    if [ ! "$(whoami)" = "root" -a -x "$(command -v sudo)" ]; then
        cmd+=(sudo)
    fi
    if [ -x "$(command -v apt)" ]; then
        cmd+=(apt update)
    elif [ -x "$(command -v pacman)" ]; then
        cmd+=(pacman -Syy)
    elif [ -x "$(command -v brew)" ]; then
        cmd=(brew update)
    fi
    if [ "${#cmd[@]}" -gt 0 ]; then
        "${cmd[@]}"
    fi

    cmd=()
    if [ ! "$(whoami)" = "root" -a -x "$(command -v sudo)" ]; then
        cmd+=(sudo)
    fi
    if [ -x "$(command -v yum)" ]; then
        cmd+=(yum install -y git which bison gcc gcc-c++ make curl)
    elif [ -x "$(command -v apt)" ]; then
        cmd+=(apt install -y git curl build-essential bison)
    elif [ -x "$(command -v pacman)" ]; then
        cmd+=(pacman -S --noconfirm git which bison base-devel curl)
    elif [ -x "$(command -v brew)" ]; then
        cmd+=(brew install git bison curl)
    else
        echo "Error: unknown operating system!"
        return 1
    fi
    "${cmd[@]}"
}

function gdir_env_install_toolchain
{
    if [ ! -s "${HOME}/.gvm/scripts/gvm" ]; then
        curl -Lso- https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
    fi
    source "${HOME}/.gvm/scripts/gvm"
    gvm install go1.14.3 -B
    gvm use go1.14.3 --default
}

gdir_env_install_pkgs \
    && gdir_env_install_toolchain \
    && echo "gdir environment setup finished!" \
    && echo "You are now ready to continue gdir configuration and deployment."
