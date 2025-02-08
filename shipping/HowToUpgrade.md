# Upgrading firmware and FPGA load

Upgrading is a two-step process - the FPGA load is updated using an Altera/Intel USB Blaster, and the firmware is flashed using a regular USB mini cable.

## Flashing the FPGA

The FPGA load only has to be updated if the version number has changed. The first eight digits of the "Hardware" revision (in this case "0015" and "0019") indicate the current major and minor version number. In the release's `fpga` folder you will find several files for the F256K and for the F256 Jr. The part of the filename called eg. `RC15_XXXX` is the major and minor version number of the new load. If it is greater than the current version, you have to flash the FPGA. You should of course select the file that is suitable for your computer, either `F256K` or `F256Jr`. The latest FPGA load for the Jr. is named `F256M_Wbh_Jan4th_2025_RC19_0100.jic`.

If you're already familiar with FPGA's and using a USB Blaster you can just go right ahead, there's nothing special about the F256's.

If you are unsure how, there's an [easy to follow video](https://www.youtube.com/watch?v=U7bq7t_qjxg&ab_channel=AnyBitFeverDreams) explaining how to do it on an F256 computer.

## Flashing the firmware

Stefany Allaire has put together [an easy to follow video](https://www.youtube.com/watch?v=Zgyhy_cBsM8&ab_channel=FoenixRetroSystems) on how to update your F256, which is highly recommended. You can, of course, ignore the parts on where to download the firmware components, as these are all included in this distribution.

To flash the firmware you will need a computer and a mini USB cable. The cable should be connected to your computer and the F256 mini USB debug port (there is only one).

You will find the firmware in the `firmware` directory. In the directory everything you need to update is included. The flash tool is written in Python 3, so Python 3 must be installed, if this tool is used. On Linux this can be as simple as `sudo apt install python3 python3-pip`. On Linux you should also install
the package `python-is-python3` if the command `python` does not exist.

When it is connected, and the F256 is powered on, a serial port should appear, either in the Device Manager (on Windows) or perhaps as `/dev/ttyUSB0` on Linux. On Linux you can always try `sudo dmesg` if you need a hint as to what port is used. The flash tool can also help identify the port, to get a list of the serial ports on the machine, `python fnxmgr.zip --list-ports` will give a list of the serial ports on the machine, an example could be:

```
	/dev/ttyS0
	   Description: ttyS0
	   Manufacturer: None
	   Product: None

	/dev/ttyUSB0
	   Description: XR21B1411
	   Manufacturer: Exar Corp.
	   Product: XR21B1411
```

The connection to the F256 is the "Exar Corp" serial port, e.g. /dev/ttyUSB0

To update the firmware on Linux, you can use `source update.sh`, or `source update.sh` as root, if the serial port requires root access. This scripts assumes the port is `/dev/ttyUSB0` (which is likely the case), but if it isn't, you can easily edit the script and replace the obvious port name.

On Windows the process is similar, but you can use `update.bat` instead. You also may have to modify `update.bat` to use the correct COM-Port. Please install the serial port driver `XR21x_Win10_V2.7.0.0.zip` which can be found in the `firmware` directory. On Windows this driver is **neccessary** in order to talk to the USB debug port of your Foenix.

