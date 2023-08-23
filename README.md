# Foenix F256 firmware flash
This repository is the distribution and development hub for the Foenix F256 line of modern retro computers. It pulls together the different components that make up the flash content, and includes the latest FPGA loads.

**To download the latest firmware and FPGA loads**, please visit the [Releases](releases) page.

**For instructions on how to upgrade**, please see the [Upgrade](HowToUpgrade.md) document.

Please see [this document](Changes.md) for a list of changes and features currently in testing.

## Building
To work on the firmware or build it from scratch, clone the repository recursively:

```
git clone --rec https://github.com/csoren/f256-flash.git
```

Run the `build` recipe, this will give you a `_build` directory containing the necessary components for flashing the F256 computer.

```
just build
```

To flash the F256, use the flash recipe:

```
just flash
```

This assumes the serial port to use is `/dev/ttyUSB0`, if that is not the case, you can provide the port to use as an argument

```
just flash /dev/ttyUSB0
```
