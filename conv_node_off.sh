#!/bin/sh
for i in *.ASM; do
	echo $i
	sed -b -f conv_node_off.sed --in-place=.sedbak $i
done
