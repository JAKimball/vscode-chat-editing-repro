#!/usr/bin/env bash
# Scenario B seed file: three independent functions for the agent to edit
# across three separate kept rounds (farewell, repeat, banner-modify).

greet() {
    echo "Hello, ${1:-world}!"
}

sum() {
    echo $(( $1 + $2 ))
}

banner() {
    echo "=== ${1:-MESSAGE} ==="
}
