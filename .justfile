build_dir := "_build"

build:
    #!/bin/sh
    rm -rf {{build_dir}}
    mkdir -p {{build_dir}}

    cd extern/kernel_dos
    make dos_jr.bin
    cd ../..
    cp extern/kernel_dos/dos_jr.bin {{build_dir}}/dos.bin

    cp extern/superbasic/howto/update/bulk.csv {{build_dir}}
    cp extern/superbasic/howto/update/sb0?.bin {{build_dir}}
    cp extern/superbasic/howto/update/lockout.bin {{build_dir}}

    cp extern/kernel_dos/kernel/3?.bin {{build_dir}}

    #cp extern/pexec_gadget.bin {{build_dir}}/pexec.bin
    cp extern/superbasic/howto/update/pexec.bin {{build_dir}}

    cp extern/superbasic/howto/update/fnxmgr.zip {{build_dir}}


@flash port="/dev/ttyUSB0": build
    cd {{build_dir}}; python fnxmgr.zip --port {{port}} --flash-bulk bulk.csv
    