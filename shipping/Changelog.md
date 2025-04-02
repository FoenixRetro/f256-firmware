# 2025.9

### f/manager

Add latest version

# 2025.8

### Kernel

Double the delay (now ~/0.6 seconds) before PS2 ident...

# 2025.7

### f/manager

Add latest version

### moreorless

First version to include the text editor moreorlesss

### fcart

First version to include this tool which can be used to write data to flash cartridges

### 
# 2025.6

### Kernel

Integrate Stef's k2_lcd init changes (k2_lcd moved to f256)

Init the audio mixer's analog ports based on board id.

RTC: don't whack lower (6) alarm bits.

# 2025.5

### Kernel

Don't auto-boot carts if DIP1 (the first one) is on.

# 2025.4

Add latest FPGA load for F256 Jr.

# 2025.3

Add latest FPGA load for the F256K

# 2025.2

Update documentation

# 2025.1

### Kernel

Update the K2 Optical Keyboard driver for the production board.

SDC: flush block writes; remove debug code from block reads.

### FoenixMgr

Merge pull request pweingar#14 from dwsJason/zero_kernel_args

Erase Command

### FPGA

Add a new load for the Jr. and the K

# 2024.4

### f/manager

First release to include f/manager

# 2024.3

### pexec

Allow to start a program from all devices not just device 0.

# 2024.2

### SuperBASIC

Fix problem with function keys on F256K keyboard.

# 2024.1

**Overall** This release updates all components to their most current versions as of February 8th 2024. Additonally `wget` has been added as a new component.

### Kernel

Kernel docs: note DIP6 function on the F256K, fix a typo.

Binary prebuilds now included with commits.

F256K: TCP: DIP6 selects smaller windows.

F-Keys on scanned matrix keyboards now set the meta flag.

TCP: handle rx sequence 32-bit wrap-around (*rare*).

Larger TCP windows, PS2 KBD is ID #1, minor SD LED fix.

TCP: fixes partial ACKs and TCP.Recv status; implements Close.

### SuperBASIC

Fixed wrong error reporting in `verify` command.

Add autorepeat functionality in BASIC editor

Fix syntax error when using @ operator

Make function keys work again after kernel change in meta flags for function keys

### pexec

Slot 5 remapping wasn't working due to a type-o, which also was leaving mmu in a bad state.

pexec: updates to make the loading prettier, and communicate what pexec does more clearly. Also clear the screen when viewing pictures.

Close file after loading PGZ, and increment version

Fix issue where decompress pixels could return a bogus error

TermPUTS, fix bug where if a <CR> is encountered, and it causes the screen to scroll, share temp variables may cause an infinite number of linefeeds to happen

term.s: fix issue with the stack if the screen scrolls, but not by a CR

term: fix bug TermPrintAI, numbers above 99 were not printing out correctly.

### xdev

xdev: unmap itself out of slot 5, leave slot 5 mapped to block 5 when program starts

TermPUTS, fix bug where if a <CR> is encountered, and it causes the screen to scroll, share temp variables may cause an infinite number of linefeeds to happen

term.s: fix issue with the stack if the screen scrolls, but not by a CR

term: fix bug TermPrintAI, numbers above 99 were not printing out correctly.

pcopy: add support for file copy request form the FoenixMgr

### BASIC help

Support various keys for going back.

Make sure we stay away from certain 65C02 instructions to make the code 816 compatible.

### DOS

New "lsf" command for listing flash programs.

Displays flash program block info, headlines added

Added support for quoted arguments

# 2023.5

### DOS
It is now possible to quote strings on the commandline, enabling spaces in arguments.

Display of flash resident programs moved to new `lsf` command, and it now also shows block information.

A splash of color for headlines and prompts.

### Kernel
TCP: fixes partial ACKs and TCP.Recv status; implements Close.

# 2023.4
**Overall** - This firmware release adds the ability to display the installed flash resident programs. In DOS these are now displayed by the `help` command. Kernel user programs are now able to communicate their parameters and a description string to the user. Descriptions have been added to all firmware componenents. To enable this feature, the kernel user program header has been bumped to version 1 and extended.

### DOS
The `help` command will now display installed programs in expansion memory and on-board flash.

Allow "slash" prefix to command, both for consistency with SuperBASIC, but it will also bypass matching internal commands, enabling execution of same named resident programs, such as `help`.

### SuperBASIC
Increased expression stack, allowing more procedure parameters, and more complex expressions. Added checking and error reporting..

Added description string to SuperBASIC.

### SuperBASIC help viewer
Added description string. ESC key now handled on Jr.

### DOS
Added description string to DOS.

### pexec (-)
Added description string to pexec.

### xdev
Added new crossdev firmware module. With latest FoenixMgr, runpgx, and runpgz now can use a springboard that exists in the firmware, removing the requirement for expansion RAM. Also, if the kit is in RAM mode, the start address of the program will get poked into the reset vector as well (like the original code). Pcopy has been moved into this same module, the utility to copy files to your SDCARD.  Sometimes the machine does not reset properly when running a command from FoenixMgr.  This can make it seem like runpgx, runpgz, or pcopy is not working. If this happens, pressing reset on the physical machine usually fixes the issue.

**A note on pcopy**: The checksum and filewriter are slow.  Wait for the program to report an error, or that the file copy is complete.  There will be optimizations to make this better, for now it's fine for small files.  Since the file being copied is just in main RAM, it has a filesize limitation of about 440k bytes.

# 2023.3
This version contains no changes relevant to the F256 Jr.

### Kernel
The TinyCore MicroKernel has been updated to the latest version.

This version fixes the the F256K keyboard map. TAB and RALT were swapped, and the ALT logic was looking at the Foenix key.


# 2023.2

### FPGA
Updated F256 Jr FPGA load.

### Kernel
The TinyCore MicroKernel has been updated to the latest version. This requires an update to the FPGA load, which is included.

The kernel now fails when trying to save a file with an empty filename.

### DOS
A new `cp` (copy) command has been added to DOS.

Delete and run external command now respect drive prefix.

### SuperBASIC
The "slash", `load`, and `new` commands will now ask the user if they want to continue, if there are any unsaved changes.

Displays proper error message when file not found on SD card.

### pexec (-)
Occasional failure when opening file to load fixed.

### Help system
The [help system](https://github.com/wibbe/foenix-help) by wibbe has been added. It can be accessed from SuperBASIC by typing `/help`.


# 2023.1
New, safe, TinyCore compatible method of parameter passing between programs implemented across the board.

### DOS
Verbose bootscreen text moved to "about" command.

Loading of kernel user programs from disk implemented.

Passing of parameters implemented when starting kernel user programs.

### SuperBASIC
When launching a resident kernel user program with the `/` command, parameters are also passed to the program using the new parameter passing method. An error is now also printed if the program is not found.

### pexec (-)
`pexec` now gets the program name from the parameters passed using the new method. Any remaining parameters are passed on to the chainloaded program via the same mechanism.

Functionality to also read 32 bit PGz files has been implemented for completeness.

General speed up when reading files.

Now also clears the character color attributes and hides the cursor.
