.ONESHELL:

PASS=arb_pri arb_rr csc csc2 fir getmi_pri iir setmi_rr
DISABLED=matrix matrix1 

test:
	for i in $(PASS); do echo "=== $$i ===" ; make -C $$i test || exit 1; done
	@echo "All tests runned passed"

gls:
	for i in $(PASS); do echo "=== $$i ===" ; make -C $$i gls || exit 1; done
	@echo "All tests runned passed"

clean:
	for i in $(PASS); do echo "=== $$i ===" ; make -C $$i clean || exit 1; done
	for i in $(DISABLED); do echo "=== $$i ===" ; make -C $$i clean || exit 1; done
