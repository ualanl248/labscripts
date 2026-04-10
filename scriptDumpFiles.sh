#!/bin/bash

YELLOW='\e[33m'
BLUE='\e[34m'
NC='\e[0m'

mkdir -p ~/outputs/archivos

mapfile -t offsets < <(cat filescan.txt | grep "DVWA" | awk '{print $1}')

for offset in "${offsets[@]}"; do
  vol.py -f /media/adolfo/DATA/Ubuntu/temp_extract_dir/Breach/memdump.mem --profile=VistaSP1x86 dumpfiles -Q $offset -D ~/outputs/archivos
done

mapfile -t archivos < <(ls -l archivos| awk 'NR>1 {print $9}' | awk '{print $1}')

for archivo in "${archivos[@]}"; do
  md5sum ~/outputs/archivos/$archivo >> ~/outputs/archivos/hashes.txt
done



