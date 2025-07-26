#!/usr/bin/env bash

# Switch to wlogout remap
sudo keydctl load wlogout

# Launch wlogout
wlogout -b 5

# After it exits, restore original keymap
sudo keydctl load default
