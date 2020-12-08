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

tools: spectector klee zombmc

spectector:
	@echo "Running Spectector"
	@bash run-spectector.sh

klee:
	@echo "Running KLEE"
	@bash run-klee.sh

zombmc:
	@echo "Running Zom-B-MC"
	@bash run-zombmc.sh

clean: clean-asm clean-bc clean-bpl clean-log

clean-log:
	@echo "Removing log files"
	@rm -r ../../output/logs/klee*
	@rm -r ../../output/logs/spectector*
	@rm -r ../../output/logs/zombmc*

clean-asm:
	@echo "Removing *.asm files"
	@find ../../benchmarks/spectre/asm/ -type f ! -name '*.md' -delete

clean-bc:
	@echo "Removing *.bc files"
	@rm -r klee-*
	@find ../../benchmarks/spectre/bc/ -type f ! -name '*.md' -delete

clean-bpl:
	@echo "Removing *.bpl files"
	@find ../../benchmarks/spectre/bpl/ -type f ! -name '*.md' -delete