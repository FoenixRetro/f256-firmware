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

xdev:
    #!/bin/sh
    cd extern/xdev
    merlin32 -V xdev.s
    cd ../../
    cp extern/xdev/xdev.bin {{firmware_dir}}

fnxmgr:
    #!/bin/sh
    cd extern/fnxmgr/FoenixMgr
    cp fnxmgr.py __main__.py
    rm ../../../shipping/firmware/fnxmgr.zip
    zip ../../../shipping/firmware/fnxmgr.zip *.py -x fnxmgr.py
    rm __main__.py    
    cd ../../..

@flash port="/dev/ttyUSB0":
    cd {{firmware_dir}}; python fnxmgr.zip --target f256k --port {{port}} --flash-bulk bulk.csv
    
@flash-dos port="/dev/ttyUSB0": dos
    cd {{firmware_dir}}; python fnxmgr.zip --target f256k --port {{port}} --flash dos.bin --flash-sector 6
    
@flash-xdev port="/dev/ttyUSB0": xdev
    cd {{firmware_dir}}; python fnxmgr.zip --target f256k --port {{port}} --flash xdev.bin --flash-sector 1
    
@flash-docs-exe port="/dev/ttyUSB0": docs
    cd {{firmware_dir}}; python fnxmgr.zip --target f256k --port {{port}} --flash help.bin --flash-sector 10
    
@flash-basic port="/dev/ttyUSB0": basic
    cd {{firmware_dir}}; python fnxmgr.zip --target f256k --port {{port}} --flash-bulk ../../basic_bulk.csv
    
@flash-pexec port="/dev/ttyUSB0": pexec
    cd {{firmware_dir}}; python fnxmgr.zip --target f256k --port {{port}} --flash pexec.bin --flash-sector 7
    
@run-dos port="/dev/ttyUSB0": dos
    cd {{firmware_dir}}; python fnxmgr.zip --target f256k --port {{port}} --binary dos.bin --address A000
    
@clean:
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
