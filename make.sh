#!/bin/bash

source ~/emsdk/emsdk_env.sh

CC="emcc"

DESTINATIONS="$(cat ~/.screeps_server_directory)"
FUNCTIONS="init isInitialized initData run debug reset"\
" addRoom setCurrentRoomMember getCurrentRoomMember selectNextRoom isCurrentRoomActive"\
" addCreep setCurrentCreepMember getCurrentCreepMember selectNextCreep isCurrentCreepActive"\
" addStructure setCurrentStructureMember getCurrentStructureMember selectNextStructure isCurrentStructureActive"\
" getCurrentOrderMember getCurrentOrderData selectNextOrder isCurrentOrderActive isCurrentOrderRecieved setCurrentOrderRecieved"



CCFUNCTIONS="[";	  
for f in $FUNCTIONS; do
	if [ "$CCFUNCTIONS" != "[" ]; then
		CCFUNCTIONS+=",";
	fi
	CCFUNCTIONS+="'_${f}'";
done
CCFUNCTIONS+="]";

CCFILES="core.c room.c creep.c structure.c order.c orderTools.c orderFactory.c orders/spawn.c"
CCTARGET="core.wasm"
CCFLAGS="-s WASM=1 -s SIDE_MODULE=1 -s EXPORTED_FUNCTIONS=${CCFUNCTIONS} -O3"

echo ${CC} ${CCFLAGS} -o ${CCTARGET} ${CCFILES}
${CC} ${CCFLAGS} -o ${CCTARGET} ${CCFILES}
if [ "$?" != "0" ]; then	
	echo "building error"
	exit 1;
fi
ls -cl ${CCTARGET}

for d in $DESTINATIONS; do
	echo "copying files to $d"
	cp ../*.js $d
	cp core.wasm $d
done
