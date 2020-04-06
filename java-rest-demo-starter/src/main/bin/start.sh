#!/bin/bash

#set -x

SELF_DIR=$(cd $(dirname $0) && pwd)

/bin/sh -cl "$SELF_DIR/control.sh start"
