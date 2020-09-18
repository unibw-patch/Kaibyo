all: benchmarks tools

benchmarks: asm bc bpl

asm:
	@echo "Compiling to Asm"
	@bash C2Asm.sh

bc:
	@echo "Compiling to LLVM bytecode"
	@bash C2Bc.sh

bpl:
	@echo "Compiling to Boogie"
	@bash C2Bpl.sh

tools: klee spectector zombmc

klee:
	@echo "Running KLEE"
	@bash run-klee.sh

spectector:
	@echo "Running Spectector"
	@bash run-spectector.sh

zombmc:
	@echo "Running ZOMBMC"
	@bash run-zombmc.sh

clean: clean-asm clean-bc clean-bpl

clean-asm:
	@rm ../../output/logs/asm

clean-bc:
	@rm -r ../../output/logs/bc

clean-bpl:
	@rm ../../output/logs/bpl
	
