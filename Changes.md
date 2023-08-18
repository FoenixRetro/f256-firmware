# Updates since last shipping release
A number of changes have been implemented, both new features but also some warts have been removed.

The TL;DR is: **We can now reliably use `pexec` to launch programs from both DOS and SuperBASIC.**

 DOS and SuperBASIC can't load PGZ and PGX, these tasks are delegated to `pexec` with the `-` executable name. SuperBASIC's `/` command can be used to launch any flash resident user program, `-` is `pexec`. To launch a program from SuperBASIC, `/- program.pgz` can be used. To launch a program from DOS, `- program.pgz` is used. 

DOS can also load a kernel user program (or "KUP") from disk, these could until now only be run from flash. This does not require using `-`.

To try some of these features, copy the programs in the `samples` directory to an SD card. To switch from SuperBASIC to DOS, issue the command `/dos`. To switch from DOS to SuperBASIC, issue the command `basic`. There's a few "hello, world" type programs, and the bouncing, multiplexed balls demo.

In DOS you can try:

`- hello.pgx`

`- hello.pgz Hello World`

`hello.kup Hello World`

`balls.kup`

In SuperBASIC you can try:

`/- hello.pgx`

`/- hello.pgz Hello World`

# Executables
We have three (four, if you count the PGZ variants) executable formats, each with slightly different properties and use cases. KUP was always there, but can now also be loaded from disk.

* KUP - on disk: can only be run from DOS and can return in a controlled manner to DOS. This is useful for small utility and helper programs. Can include 32 KiB of code/data from $2000-$9FFF.
* KUP - in flash: resident program that can be run from DOS or SuperBASIC using its `/` command.
* PGX - a simple, single segment executable. Can be loaded as low as $0200. Must be loaded using `-`.
* PGZ - a multi-segment executable. Can be loaded as low as $0200. Must be loaded using `-`.

# Parameter passing
Parameters are passed using both the kernel argument block, and the memory page at $0200. If a program wants to use the parameters, it must not use (or load into) the range $0200-$02FF before the parameters are no longer used.

Arguments are passed in the `ext` and `extlen` kernel arguments. This approach has been cleared with Jessie Oberreuter, the TinyCore author, and is also suitable for passing arguments through the `RunNamed` and `RunBlock` kernel functions.

`ext` will contain an array of pointers, one for each argument given on the command line. The first pointer is the program name itself. The list is terminated with a null pointer. `extlen` contains the length in bytes of the array, less the null pointer. For instance, if two parameters are passed, `extlen` will be 4.

# Returning from a program
A KUP loaded from disk may exit back to DOS by issuing an RTS instruction. Additionally the carry may be set if the machine should be reset, or carry clear to continue running DOS. Be aware that you must leave the MMU configuration in the state you found it. You should also keep away from the $0200-$07FF range completely.

# Future work
`balls.kup` should be `balls.pgz`. In the sample distribution, the ball sprite demo is a .kup. KUPs should only be used for programs that extend and augment DOS. Other programs, such as demos and games, should be distributed as .pgx or .pgz so thay can be launched from both DOS and SuperBASIC.

The `keys` program should be moved out of DOS and made a KUP.

A `copy` command will be implemented in DOS.

# Details
These are some more details on the changes.

## F256 Jr
Four characters in the SuperBASIC header had wrong attributes, these are now fixed.

## Parameter passing
A reliable method of passing parameters to programs has been implemented. This enables DOS and SuperBASIC to pass parameters to a program when launched.

## DOS
Functionality to load a Kernel User Program from disk has been added.

The new parameter passing method is used when launching user programs, either resident or from disk.

The welcome text has been reduced, information moved to an `about` command. We just got here from SuperBASIC, we know this and don't need it right in the face every time.

## SuperBASIC
When launching a resident kernel user program with the `/` command, parameters are also passed to the program using the new parameter passing method. An error is now also printed if the program is not found.

## pexec, -
`pexec` is the program also known as `-`.

`pexec` now gets the program name from the parameters passed using the new method. Any remaining parameters are passed on to the chainloaded program via the same mechanism.

Functionality to also read 32 bit PGz files has been implemented for completeness.

General speed up when reading files.

Now also clears the character color attributes and hides the cursor.
