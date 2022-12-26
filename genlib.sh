#!/bin/bash

PP="../pppl/pp.pl -I .. -d ../gen -q"
AUTOEXP="../vlog_expand_autos/vlog_expand_autos.pl"

if [ -d ./gen ]; then
    rm -rf ./gen
fi
mkdir ./gen

pushd lib || { echo "ERROR: cannot cd to lib"; exit 1; }
$PP pp.buffer.v -p fifo_depth=2
$PP pp.buffer.v -p fifo_depth=10
$PP pp.range.v 
$PP -p op="'+'" -p mod=sum_reduce pp.reduce_template.v
$PP pp.wait_for_all.v -p n=2 -p fifo_depth=2
$PP pp.wait_for_all.v -p n=3 -p fifo_depth=2
$PP pp.getmi.v
$PP pp.setmi.v
$PP pp.arb.v -p rr=0 -p n=2
$PP pp.arb.v -p rr=1 -p n=2
$PP pp.arb.v -p rr=0 -p n=3
$PP pp.arb.v -p rr=1 -p n=3
$PP -p n=1 -p op="'x0'" -p mod=regin  pp.templatenx1.v
$PP -p n=1 -p op="'x0'" -p mod=regout pp.templatenx1.v
$PP -p n=1 -p op="'x0'" -p mod=bufin  pp.templatenx1_combo.v
$PP -p n=1 -p op="'x0'" -p mod=bufout pp.templatenx1_combo.v
$PP -p n=2 -p op="'x0 - x1'" -p mod=sub_2 pp.templatenx1.v
$PP -p n=2 -p op="'x0 * x1'" -p mod=mul_2       pp.templatenx1.v
$PP -p n=2 -p op="'x0 * x1'" -p mod=combo_mul_2 pp.templatenx1_combo.v
$PP -p n=2 -p op="'x0 + x1'"               -p mod=sum_2 pp.templatenx1.v
$PP -p n=3 -p op="'x0 + x1 + x2'"          -p mod=sum_3 pp.templatenx1.v
$PP -p n=4 -p op="'(x0 + x1) + (x2 + x3)'" -p mod=sum_4 pp.templatenx1.v
$PP -p n=2 -p op="'x0 + x1'"               -p mod=combo_sum_2 pp.templatenx1_combo.v
$PP -p n=3 -p op="'x0 + x1 + x2'"          -p mod=combo_sum_3 pp.templatenx1_combo.v
$PP -p n=4 -p op="'(x0 + x1) + (x2 + x3)'" -p mod=combo_sum_4 pp.templatenx1_combo.v
$PP -p n=1 -p op="'~x0'"     -p mod=inv pp.templatenx1.v
$PP -p n=1 -p op="'-x0'"     -p mod=chs pp.templatenx1.v
$PP -p n="1"  pp.delay_line_template.v
$PP -p n="2"  pp.delay_line_template.v
$PP -p n="3"  pp.delay_line_template.v
$PP -p n="4"  pp.delay_line_template.v
$PP -p n="1"  pp.delay_template.v
$PP -p n="2"  pp.delay_template.v
$PP -p n="3"  pp.delay_template.v
$PP -p n="4"  pp.delay_template.v
$PP  pp.gen_seq.v
$PP  pp.cross_seqx2.v
$PP  pp.dup.v
$PP -p n="2"  pp.converge_flags_template.v
$PP -p n="3"  pp.converge_flags_template.v
$PP -p n=3  pp.one_to_many_template.v
$PP pp.data_mem.v
$PP pp.data_mem_be.v
popd

pushd gen
for f in $(ls *.v); do
    echo "-- expanding autos in $f --"
    $AUTOEXP $f -o $f
done
popd

exit 0
