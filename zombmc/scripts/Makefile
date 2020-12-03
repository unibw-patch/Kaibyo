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

docker-asm: asm save-asm

docker-bc: bc save-bc

docker-bpl: bpl save-bpl

docker-benchmarks: docker-asm docker-bc docker-bpl

save-asm:
	@echo "Saving *.asm files"
	@cp ${DAT3M_HOME}/benchmarks/spectre/asm/*.s /data/asm

save-bc:
	@echo "Saving *.bc files"
	@cp ${DAT3M_HOME}/benchmarks/spectre/bc/*.bc /data/bc

save-bpl:
	@echo "Saving *.bpl files"
	@cp ${DAT3M_HOME}/benchmarks/spectre/bpl/*.bpl /data/bpl

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

docker-spectector: spectector save-spectector

docker-klee: klee save-klee

docker-zombmc: zombmc save-zombmc

docker-tools: docker-spectector docker-klee docker-zombmc save-logs

docker-all: docker-benchmarks docker-tools

save-logs:
	@echo "Saving logs"
	@cp -r ${DAT3M_HOME}/output/logs /data

save-spectector:
	@echo "Saving Spectector results"
	@cp ${DAT3M_HOME}/output/spectector-results.csv /data
	@cp ${DAT3M_HOME}/output/spectector-times.csv /data

save-klee:
	@echo "Saving KLEE results"
	@cp ${DAT3M_HOME}/output/klee-results.csv /data
	@cp ${DAT3M_HOME}/output/klee-times.csv /data

save-zombmc:
	@echo "Saving Zom-B-MC results"
	@cp ${DAT3M_HOME}/output/zombmc-results.csv /data
	@cp ${DAT3M_HOME}/output/zombmc-times.csv /data

clean: clean-asm clean-bc clean-bpl

clean-asm:
	@echo "Removing *.asm files"
	@find ../../benchmarks/spectre/asm/ -type f ! -name '*.md' -delete

clean-bc:
	@echo "Removing *.bc files"
	@find ../../benchmarks/spectre/bc/ -type f ! -name '*.md' -delete

clean-bpl:
	@echo "Removing *.bpl files"
	@find ../../benchmarks/spectre/bpl/ -type f ! -name '*.md' -delete