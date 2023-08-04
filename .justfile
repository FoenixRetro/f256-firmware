build_dir := "_build"
release_zip := "firmware.zip"

build:
    #!/bin/sh
    rm -rf {{build_dir}}
    mkdir -p {{build_dir}}

    cp extern/shipping/* {{build_dir}}

    cd extern/hello
    make
    cd ../..
    cp extern/hello/hello {{build_dir}}

    cd extern/kernel_dos
    make dos_jr.bin
    cd ../..
    cp extern/kernel_dos/dos_jr.bin {{build_dir}}/dos.bin

    cp extern/kernel_dos/kernel/3?.bin {{build_dir}}

    rm {{release_zip}}
    cd {{build_dir}}; zip ../{{release_zip}} * 


@flash port="/dev/ttyUSB0": build
    cd {{build_dir}}; python fnxmgr.zip --port {{port}} --flash-bulk bulk.csv
    
@clear:
	dd if=/dev/zero of=_zero.bin bs=1024 count=64
	fnxmgr --address 0 --binary _zero.bin
	rm _zero.bin

