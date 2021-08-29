# Kaibyo

<p align="center"> 
<img src="kaibyo/src/main/resources/cat-ghost.png" width="400">
</p>

Kaibyo is an extension of the [Dat3M](https://github.com/hernanponcedeleon/Dat3M) framework which allows to test software isolation of programs running on parametric microarchitectural models defined using the CAT language.

Requirements
======
* [Maven](https://maven.apache.org/) (to build the tool)
* [GCC 8.3.0](https://gcc.gnu.org/gcc-8/) (to compile C programs to x86 assembly)

Installation
======
Download the z3 dependency
```
mvn install:install-file -Dfile=lib/z3-4.8.6.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.8.6 -Dpackaging=jar
```
Set Dat3M's home, the path and shared libraries variables (replace the latter by DYLD_LIBRARY_PATH in **MacOS**)
```
export DAT3M_HOME=<Dat3M's root>
export PATH=$DAT3M_HOME/:$PATH
export LD_LIBRARY_PATH=$DAT3M_HOME/lib/:$LD_LIBRARY_PATH
```

To build the tool run
```
mvn clean install
```

Usage
======
The input program must be given as a `.s` file, i.e. x86 assembly code with Intel syntax (our examples for spectre `PHT`, `STL` and `PSF` can be found in `DAT3M_HOME/benchmarks`).

The microarchitecture must be defined as a CAT file (see `DAT3M_HOME/cat` for examples).

For checking software isolation run:
```
java -jar kaibyo/target/kaibyo-2.0.7-jar-with-dependencies.jar -input <program file> -cat <CAT file> [options]
```
Options include:
- `-unroll`: unrolling bound for the BMC.
- `-entry`: Name of the entry function (default `main`)
- `-sectey`: Name of the variable containing the secret (default `secret`)
- `-branch_speculation`: It enables branch speculation.
- `-branch_speculation_error`: It only looks for isolation violations along a transient control flow.
- `-alias_speculation`: It enables alias branch speculation.

Authors and Contact
======
* [Hernán Ponce de León](mailto:hernan.ponce@unibw.de)
* [Johannes Kinder](mailto:johannes.kinder@unibw.de)

Please feel free to contact us in case of questions or to send feedback.
