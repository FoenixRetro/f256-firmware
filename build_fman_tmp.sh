#!/bin/zsh

DEV=~/dev/bbedit-workspace-foenix
STATSIZE="-f%z"

if [[ $# -ne 0 ]]; then
  echo "Linux mode"
  DEV=$1
  STATSIZE="--format=%s"
fi

PROJECT=$DEV/F256jr-FileManager
CONFIG_DIR=$PROJECT/config_cc65

# name that will be used in files
VERSION_STRING="1.0b24"

# debug logging levels: 1=error, 2=warn, 3=info, 4=debug general, 5=allocations
#DEBUG_DEF_1="-DLOG_LEVEL_1"
#DEBUG_DEF_2="-DLOG_LEVEL_2"
#DEBUG_DEF_3="-DLOG_LEVEL_3"
#DEBUG_DEF_4="-DLOG_LEVEL_4"
#DEBUG_DEF_5="-DLOG_LEVEL_5"
DEBUG_DEF_1=
DEBUG_DEF_2=
DEBUG_DEF_3=
DEBUG_DEF_4=
DEBUG_DEF_5=

# whether disk or serial debug will be used, IF debug is actually on
# defining serial debug means serial will be used, not defining it means disk will be used. 
DEBUG_VIA_SERIAL="-DUSE_SERIAL_LOGGING"
#DEBUG_VIA_SERIAL=

#STACK_CHECK="--check-stack"
STACK_CHECK=

#optimization
#OPTI=-Oirs
OPTI=-Os

BUILD_DIR=$PROJECT/build_cc65
TARGET_DEFS="-D_TRY_TO_WRITE_TO_DISK"
#PLATFORM_DEFS="-D_SIMULATOR_" #do not define simulator if running on real hardware
PLATFORM_DEFS= #do not define simulator if running on real hardware
CC65TGT=none
CC65LIB=$CONFIG_DIR/lib/f256_lichking_only.lib
CC65CPU=65C02
EMULATOR=/Users/micahbly/dev/bbedit-workspace-foenix/junior-emulator/emulator/jr256
OVERLAY_CONFIG=fmanager_overlay_f256.cfg
DATADIR=data

cd $PROJECT

echo "\n**************************\nCC65 compile start...\n**************************\n"
which cc65

mkdir -p $BUILD_DIR
mkdir -p $BUILD_DIR/fm_install/
mkdir -p $BUILD_DIR/fm_install/disk
mkdir -p $BUILD_DIR/fm_install/flash

rm -r $BUILD_DIR/*.s
rm -r $BUILD_DIR/*.o

# compile
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T app.c -o $BUILD_DIR/app.s
cc65 -g --cpu $CC65CPU -t $CC65TGT --code-name OVERLAY_MEMSYS $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T bank.c -o $BUILD_DIR/bank.s
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T comm_buffer.c -o $BUILD_DIR/comm_buffer.s
cc65 -g --cpu $CC65CPU -t $CC65TGT --code-name OVERLAY_DISKSYS $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T file.c -o $BUILD_DIR/file.s
cc65 -g --cpu $CC65CPU -t $CC65TGT --code-name OVERLAY_DISKSYS $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T folder.c -o $BUILD_DIR/folder.s
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T general.c -o $BUILD_DIR/general.s
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T keyboard.c -o $BUILD_DIR/keyboard.s
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T list.c -o $BUILD_DIR/list.s
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T list_panel.c -o $BUILD_DIR/list_panel.s
cc65 -g --cpu $CC65CPU -t $CC65TGT --code-name OVERLAY_MEMSYS $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T memsys.c -o $BUILD_DIR/memsys.s
cc65 -g --cpu $CC65CPU -t $CC65TGT --code-name OVERLAY_EM $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T overlay_em.c -o $BUILD_DIR/overlay_em.s
cc65 -g --cpu $CC65CPU -t $CC65TGT --code-name OVERLAY_STARTUP $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T overlay_startup.c -o $BUILD_DIR/overlay_startup.s
cc65 -g --cpu $CC65CPU -t $CC65TGT --code-name OVERLAY_SCREEN $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T screen.c -o $BUILD_DIR/screen.s
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T sys.c -o $BUILD_DIR/sys.s
cc65 -g --cpu $CC65CPU -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS $DEBUG_DEF_1 $DEBUG_DEF_2 $DEBUG_DEF_3 $DEBUG_DEF_4 $DEBUG_DEF_5 $DEBUG_VIA_SERIAL $STACK_CHECK -T text.c -o $BUILD_DIR/text.s

# Kernel access
cc65 -g --cpu 65C02 -t $CC65TGT $OPTI -I $CONFIG_DIR $TARGET_DEFS $PLATFORM_DEFS -T kernel.c -o $BUILD_DIR/kernel.s


echo "\n**************************\nCA65 assemble start...\n**************************\n"

# assemble into object files
cd $BUILD_DIR
ca65 -t $CC65TGT app.s
ca65 -t $CC65TGT bank.s
ca65 -t $CC65TGT comm_buffer.s
ca65 -t $CC65TGT file.s
ca65 -t $CC65TGT folder.s
ca65 -t $CC65TGT general.s
ca65 -t $CC65TGT keyboard.s
ca65 -t $CC65TGT list_panel.s
ca65 -t $CC65TGT list.s
ca65 -t $CC65TGT memsys.s
ca65 -t $CC65TGT overlay_em.s
ca65 -t $CC65TGT overlay_startup.s
ca65 -t $CC65TGT screen.s
ca65 -t $CC65TGT sys.s
ca65 -t $CC65TGT text.s

# Kernel access
ca65 -t $CC65TGT kernel.s -o kernel.o

# name 'header'
#ca65 -t $CC65TGT ../name.s -o name.o
ca65 -t $CC65TGT ../memory.asm -o memory.o


echo "\n**************************\nLD65 link start...\n**************************\n"

# link files into an executable
ld65 -C $CONFIG_DIR/$OVERLAY_CONFIG -o fmanager.rom kernel.o app.o bank.o comm_buffer.o file.o folder.o general.o keyboard.o list.o list_panel.o memory.o memsys.o overlay_em.o overlay_startup.o screen.o sys.o text.o $CC65LIB -m fmanager_$CC65TGT.map -Ln labels.lbl
# $PROJECT/cc65/lib/common.lib

#noTE: 2024-02-12: removed name.o as it was incompatible with the lichking-style memory map I want to use to get more memory

echo "\n**************************\nCC65 tasks complete\n**************************\n"




#copy strings to build folder
#cp fmanager.rom ../release/
#cp fmanager.rom.1 ../release/
#cp fmanager.rom.2 ../release/
#cp fmanager.rom.3 ../release/
#cp fmanager.rom.4 ../release/
cp ../strings/strings.bin .


#build pgZ for disk
fname=("fmanager.rom" "fmanager.rom.1" "fmanager.rom.2" "fmanager.rom.3" "fmanager.rom.4" "fmanager.rom.5" "strings.bin")
addr=("990700" "000001" "002001" "004001" "006001" "008001" "004002")


for ((i = 1; i <= $#fname; i++)); do
v1=$(stat $STATSIZE $fname[$i]); v2=$(printf '%04x\n' $v1); v3='00'$v2; v4=$(echo -n $v3 | tac -rs ..); v5=$addr[$i]$v4;v6=$(sed -Ee 's/([A-Za-z0-9]{2})/\\\x\1/g' <<< "$v5"); echo -n $v6 > $fname[$i]'.hdr'
done

echo -n 'Z' >> pgZ_start.hdr
echo -n '\x99\x07\x00\x00\x00\x00' >> pgZ_end.hdr

cat pgZ_start.hdr fmanager.rom.hdr fmanager.rom fmanager.rom.1.hdr fmanager.rom.1 fmanager.rom.2.hdr fmanager.rom.2 fmanager.rom.3.hdr fmanager.rom.3 fmanager.rom.4.hdr fmanager.rom.4 fmanager.rom.5.hdr fmanager.rom.5 strings.bin.hdr strings.bin pgZ_end.hdr > fm.pgZ 

rm *.hdr

cp fm.pgZ fm_install/disk/

# copy pgz binary to SD Card on F256 via fnxmanager
#python3 $FOENIXMGR/FoenixMgr/fnxmgr.py --copy fm.pgZ


# copy latest readme, etc files to the install dir
cp $PROJECT/documentation/_user_guide.md fm_install/
cp $PROJECT/documentation/installing.md fm_install/
cp $PROJECT/documentation/using.md fm_install/
cp $PROJECT/documentation/flash_configurations.png fm_install/


# copy latest flash configuration files to the flash install subdir
cp $PROJECT/flash_config/* fm_install/flash/


# build as firmware/flashware

# cat the header with KUP header and compact pexec with the pgz file
cat $PROJECT/fm_firmware_header.bin fm.pgZ > fm.bin

# split the fm.bin up  (header + cat program)
cd fm_install/flash
split -d -b8192 ../../fm.bin fm.

# make the last chunk be exactly 8k
truncate -s 8K fm.06

# zip it up
cd ../../
zip -vrq fm_"$VERSION_STRING"_install.zip fm_install/ -x "*.DS_Store"

# clear temp files
rm fmanager.ro*
rm strings.bin
rm fm.bin



echo "\n**************************\nCC65 build script complete\n**************************\n"
