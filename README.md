# Foenix F256 firmware flash
This repository is the distribution and development hub for the Foenix F256 line of modern retro computers. It pulls together the different components that make up the flash content, and includes the latest FPGA loads.

**To download the latest firmware and FPGA loads**, please visit the https://github.com/FoenixRetro/f256-firmware/releases page.

**For instructions on how to upgrade**, please see the [Upgrade](HowToUpgrade.md) document.

# What's new?
Please see [this document](Changelog.md) for a list of changes and features currently in testing.

# Working on the firmware
## Project structure
The different components comprising the firmware are included as submodules in the `extern` directory. Components are forked into the the github [FoenixRetro](https://github.com/FoenixRetro) organization, and should generally have the name `f256-<component>`.

The binaries for the next release are kept in the `shipping` directory. When making a release, this directory is zipped and the repository tagged with the version number.

## Prerequisites
The different components use several tools to build. These must be installed in order to work on the firmware. They can either be built from source, or they may already be present in the operating system's package manager.

They are:
* python (https://www.python.org/)
* 64tass (https://sourceforge.net/projects/tass64/)
* cc65 (https://cc65.github.io/)
* Merlin32 (https://github.com/lroathe/merlin32)
* zsh (https://www.zsh.org/)
* perl (https://www.perl.org/)

To work on the firmware, clone the repository recursively:

```
git clone --rec https://github.com/FoenixRetro/f256-firmware.git
```

If you have write access to the FoenixRetro organization, you must add these lines to your `.gitconfig`, as submodules are added as `https` references.

```
[url "git@github.com:FoenixRetro/"]
        insteadOf = https://github.com/FoenixRetro/
```

When pulling, please make sure you get all changes to submodules by using

```
git pull --recurse-submodules
```

## Workflow
Currently the firmware is easiest to build on Linux. It should also work on Mac and WSL on Windows. I personally (`@rmsk2`) have never tested it under Cygwin on Windows but in theory it should work too. The [`just`](https://github.com/casey/just) tool is used to manage the different workflows.

There is no recipe for building the complete firmware. Instead, components are built individually while developing. When using a recipe for building a component, the build artifacts are copied into the `shipping/firmware` directory. While keeping binary artifacts in a repository is generally considered a bad idea, in this case it is necessary, as some components will update their "built date" when building, and the binaries should not be changed when there are no changes.

Every time a feature is complete, it should be added to the `Changelog.md` file.

## Recipes
Available build recipes in the `.justfile` are:

* `just basic` - builds SuperBASIC
* `just dos` - builds DOS
* `just kernel` - builds kernel
* `just pexec` - builds pexec
* `just docs` - builds SuperBASIC help viewer
* `just xdev` - builds xdev
* `just wget` - builds wget
* `just fmanager` - builds f/manager

To flash and test a component, the following receipes are available. Be careful these recipes are probably out of date and may not work:

* `just flash` - Flashes all the components
* `just flash-dos` - Flashes only DOS
* `just flash-docs-exe` - Flashes only the SuperBASIC help viewer program, not the documentation banks
* `just flash-basic` - Flashes SuperBASIC
* `just flash-pexec` - Flashes pexec

To run a component from RAM, the recipes are available. DIP 1 must be in the "on" position.

* `just run-dos` - Uploads DOS to RAM and executes it

All flash and run recipes accept a "port" argument. The default is `/dev/ttyUSB0`.

## Preparing a release
Releases are zipped packages that are uploaded to the firmware repository's Releases page.

Version numbers use a [CalVer](https://calver.org/) variant - `YYYY.minor`. `YYYY` is the year, and `minor` is the number of the release that year, starting from 1 every year.

Before creating a release, all local changes must have been pushed to github.

There is a `release` recipe available. It accepts one parameter, the CalVer version of the release, for instance `just release 2023.2`. This will build a .zip file called `f256_firmware_2023.2.zip`. A new release should be created on the Releases page, and a new tag named `release-<CalVer>` created, for instance `release-2023.3`. The release notes should be a copy of the `Changelog.md` entry for that version.
