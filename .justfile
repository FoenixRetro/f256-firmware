build_dir := "shipping"
firmware_dir := "shipping/firmware"
samples_dir := "shipping/samples"
fpga_dir := "shipping/fpga"
release_zip := "firmware.zip"

basic:
    #!/bin/sh
    cd extern/superbasic/source
    make -B basic release
    cd ../../..
    cp extern/superbasic/source/release/sb0?.bin {{firmware_dir}}

hello:
    #!/bin/sh
    cd extern/hello
    make
    cd ../..
    cp extern/hello/hello.pgz {{samples_dir}}
    cp extern/hello/hello.kup {{samples_dir}}

hello-pgx:
    #!/bin/sh
    cd extern/dwsJason-f256/merlin32/hello
    merlin32 -V hello.s
    cd ../../../..
    cp extern/dwsJason-f256/merlin32/hello/hello.pgx {{samples_dir}}

dos:
    #!/bin/sh
    cd extern/dos
    make dos_jr.bin
    cd ../..
    cp extern/dos/dos_jr.bin {{firmware_dir}}/dos.bin

kernel:
    #!/bin/sh
    cd extern/microkernel
    make
    cd ../..
    cp extern/microkernel/3?.bin {{firmware_dir}}

pexec:
    #!/bin/sh
    cd extern/pexec
    merlin32 -V pexec.s
    cd ../../
    cp extern/pexec/pexec.bin {{firmware_dir}}

docs:
    #!/bin/sh
    cd extern/docs
    make
    cd ../..
    cp extern/docs/bin/help.bin {{firmware_dir}}
    cp extern/docs/bin/docs/docs_superbasic?.bin {{firmware_dir}}


@flash port="/dev/ttyUSB0":
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --flash-bulk bulk.csv
    
@flash-dos port="/dev/ttyUSB0": dos
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --flash dos.bin --flash-sector 5
    
@flash-docs-exe port="/dev/ttyUSB0": docs
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --flash help.bin --flash-sector 10
    
@flash-basic port="/dev/ttyUSB0": basic
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --flash-bulk ../../basic_bulk.csv
    
@run-dos port="/dev/ttyUSB0": dos
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --binary dos.bin --address A000
    
@flash-pexec port="/dev/ttyUSB0": pexec
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --flash pexec.bin --flash-sector 6
    
@clean:
    cd extern/hello; make clean
    cd extern/dwsJason-f256; rm -f pexec.bin
    cd extern/kernel_dos; rm -f kernel/dos.bin dos_jr.bin dos_jr.lst
    rm -rf {{build_dir}}

@clear:
	dd if=/dev/zero of=_zero.bin bs=1024 count=64
	fnxmgr --address 0 --binary _zero.bin
	rm _zero.bin

@release version="2023.next":
    rm -f f256_firmware_{{version}}.zip
    cp Changelog.md {{build_dir}}
    cp HowToUpgrade.md {{build_dir}}
    cp Versions.jpg {{build_dir}}
    cd {{build_dir}}; zip -r ../f256_firmware_{{version}}.zip * 
