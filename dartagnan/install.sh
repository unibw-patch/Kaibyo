#!/bin/sh

LIB="./import"
OUT="./bin"

export LD_LIBRARY_PATH=$LIB
export DYLD_LIBRARY_PATH=$LIB
export CLASSPATH=$(JARS=("$LIB"/*.jar); IFS=:; echo "${JARS[*]}")

rm -rf target/generated-sources/

java -jar import/antlr-4.7-complete.jar parsers/Cat.g4 -package dartagnan.parsers -Werror -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/
java -jar import/antlr-4.7-complete.jar parsers/Porthos.g4 -package dartagnan.parsers -Werror -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/
java -jar import/antlr-4.7-complete.jar parsers/LitmusAArch64.g4 -package dartagnan.parsers -Werror -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/
java -jar import/antlr-4.7-complete.jar parsers/LitmusC.g4 -package dartagnan.parsers -Werror -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/
java -jar import/antlr-4.7-complete.jar parsers/LitmusPPC.g4 -package dartagnan.parsers -Werror -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/
java -jar import/antlr-4.7-complete.jar parsers/LitmusX86.g4 -package dartagnan.parsers -Werror -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/
java -jar import/antlr-4.7-complete.jar parsers/LitmusAssertions.g4 -package dartagnan.parsers -Werror -no-listener -visitor -o target/generated-sources/antlr4/dartagnan/

mkdir -p $OUT
find src -name *.java > sources.txt
find target -name *.java >> sources.txt
javac -d $OUT @sources.txt
rm sources.txt

export CLASSPATH=$CLASSPATH:$OUT
echo "Installation finished. Set CLASSPATH:"
echo "export CLASSPATH=$CLASSPATH"