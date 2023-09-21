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
