# Background

The declarative nature of NixOS only gets me so far, there are still a few manual
steps required to set up a new computer, like formatting the hard drive.

This folder contains a bootstrap script to setup NixOS on new computers, but it
has not been updated in a long while, while my config structure has changed
substantially (for one, it has turned into a flake).

In short, `bootstrap.sh` needs an overhaul to be useful.
