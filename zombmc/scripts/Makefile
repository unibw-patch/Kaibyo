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

clean: clean-asm clean-bc clean-bpl clean-logs

clean-asm:
	@echo "Removing *.asm files"
	@find ../../benchmarks/spectre/asm/ -type f ! -name '*.md' -delete

clean-bc:
	@echo "Removing *.bc files"
	@find ../../benchmarks/spectre/bc/ -type f ! -name '*.md' -delete

clean-bpl:
	@echo "Removing *.bpl files"
	@find ../../benchmarks/spectre/bpl/ -type f ! -name '*.md' -delete

clean-logs:
	@echo "Cleaning Spectector logs"
	@find ../../output/logs/spectector/ -type f ! -name '*.md' -delete
	@echo "Cleaning KLEE logs"
	@find ../../output/logs/klee/ -type f ! -name '*.md' -delete
	@echo "Cleaning Zom-B-MC logs"
	@find ../../output/logs/zombmc/ -type f ! -name '*.md' -delete
