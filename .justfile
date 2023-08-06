build_dir := "_build"
release_zip := "firmware.zip"

build: clean shipping hello dos pexec
    cp extern/kernel_dos/kernel/3?.bin {{build_dir}}

    rm {{release_zip}}
    cd {{build_dir}}; zip ../{{release_zip}} * 

@shipping:
    #!/bin/sh
    cd extern/shipping
    cp bulk.csv fnxmgr.zip foenixmgr.ini lockout.bin README.txt SETUPHARDWARE.txt update.bat update.sh xrusbser_2600_signed_win7.zip sb*.bin {{justfile_directory()}}/{{build_dir}}

@hello:
    #!/bin/sh
    cd extern/hello
    make
    cd ../..
    cp extern/hello/hello {{build_dir}}

@dos:
    #!/bin/sh
    cd extern/kernel_dos
    make dos_jr.bin
    cd ../..
    cp extern/kernel_dos/dos_jr.bin {{build_dir}}/dos.bin

@pexec:
    #!/bin/sh
    cd extern/dwsJason-f256/merlin32/pexec
    merlin32 -V pexec.s
    cd ../../../..
    cp extern/dwsJason-f256/merlin32/pexec/pexec.bin {{build_dir}}



@flash port="/dev/ttyUSB0": build
    cd {{build_dir}}; python fnxmgr.zip --port {{port}} --flash-bulk bulk.csv
    
@flash-dos port="/dev/ttyUSB0": dos
    cd {{build_dir}}; python fnxmgr.zip --port {{port}} --flash dos.bin --flash-sector 5
    
@flash-pexec port="/dev/ttyUSB0": pexec
    cd {{build_dir}}; python fnxmgr.zip --port {{port}} --flash pexec.bin --flash-sector 6
    
@clean:
    cd extern/hello; make clean
    cd extern/dwsJason-f256; rm -f pexec.bin
    cd extern/kernel_dos; rm -f kernel/dos.bin dos_jr.bin dos_jr.lst

@clear:
	dd if=/dev/zero of=_zero.bin bs=1024 count=64
	fnxmgr --address 0 --binary _zero.bin
	rm _zero.bin

