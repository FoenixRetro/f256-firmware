build_dir := "shipping"
firmware_dir := "shipping/firmware"
samples_dir := "shipping/samples"
fpga_dir := "shipping/fpga"
release_zip := "firmware.zip"

@basic:
    #!/bin/sh
    cd extern/superbasic/source
    make -B basic release
    cd ../../..
    cp extern/superbasic/source/release/sb0?.bin {{firmware_dir}}

@hello:
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
    cd extern/kernel_dos
    make dos_jr.bin
    cd ../..
    cp extern/kernel_dos/dos_jr.bin {{firmware_dir}}/dos.bin

pexec:
    #!/bin/sh
    cd extern/dwsJason-f256/merlin32/pexec
    merlin32 -V pexec.s
    cd ../../../..
    cp extern/dwsJason-f256/merlin32/pexec/pexec.bin {{firmware_dir}}

docs:
    #!/bin/sh
    cp extern/docs/release/*.bin {{firmware_dir}}


@flash port="/dev/ttyUSB0":
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --flash-bulk bulk.csv
    
@flash-dos port="/dev/ttyUSB0": dos
    cd {{firmware_dir}}; python fnxmgr.zip --port {{port}} --flash dos.bin --flash-sector 5
    
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
    cp HowToUpgrade.md {{build_dir}}
    cp Versions.jpg {{build_dir}}
    cd {{build_dir}}; zip -r ../f256_firmware_{{version}}.zip * 
