# Foenix F256 firmware flash
This repository pulls together the different components that make up the Foenix F256 line of computers' flash content.

To use, clone the repository recursively

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
