PP ?= ../../../pppl/pp.pl
PP_OPTS ?= -q -ips dbg.pl
AUTOEXP ?= ../../../vlog_expand_autos/vlog_expand_autos.pl
S2V ?= ../../scripts/s2v.py
S2V_OPTS ?= 
CLEAN_MORE ?=
COMP=iverilog -g2005-sv -o ./sim.x 
SIM=vvp ./sim.x

%.v : pp.%.v $(PP) $(AUTOEXP)
	$(PP) $(PP_OPTS) $< -o - | $(AUTOEXP) -o $@

../../gen/%.v : ../../lib/pp.%.v $(PP) $(AUTOEXP)
	$(PP) $(PP_OPTS) $< -o - | $(AUTOEXP) -o $@

%.v : %.s $(S2V)
	$(S2V) $(S2V_OPTS) $< $@

%.run.log : %_tb.v %.v
	$(COMP) $*_tb.v $*.v
	$(SIM) | tee $*.run.log

test: $(TARGETS) $(LIB)
	$(COMP) $^ ../../tb/dump.v
	$(SIM) | tee run.log

clean: $(CLEAN_MORE)
	$(RM) $(TARGETS) dbg.pl *run.log sim.x *.vcd

.PHONY: clean

.PRECIOUS: %.vb %.v
