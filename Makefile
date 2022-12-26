
test:
	make -C examples test

clean:
	make -C examples clean
	$(RM) -r scripts/__pycache__ scripts/.mypy_cache
	$(RM) -r scripts/grammar/__pycache__ scripts/grammar/.mypy_cache
