#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

! [ -f /ccbts/.setup/completed ] && \
cd /ccbts/.setup && exec make "provision-$PLATFORM"
cd && exec bash
