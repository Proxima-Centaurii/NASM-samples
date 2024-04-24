# NASM-samples
This repository contains a few sample programs that I wrote when I began learning Assembly with NASM.

# How to run the sources?
You will need to have NASM assembler and the GNU Linker available on your system.

To make a runnable/executable follow the steps below:
1. Open a terminal in the folder of the sample you with to run (eg. '1-Hello_World')
2. Generate an object file using the following command:
```bash
# nasm -f <format> <input path> -o <output path>
nasm -f elf64 src/hello.asm -o out/hello.o
```
- After the '-f' flag is the format of the executable/runnable file. For Linux use 'elf64', MacOS has 'macho64', and Windows 'win64'. Note that all 3 formats must be 64 bit formats, hence the '64' at the end of the format name. 
- You may additionally add the '-g' flag to include debugging information if you wish to perform runtime debugging with GDB.
3. Generate an executable file
  ```bash
  # On Windows you should specify the '.exe' extension in the output file path
  # ld <input path> -o <output path>
  ld out/hello.o -o out/hello
  ```
4. Run the program from the console.
```bash
# assuming the working directory is the directory of the project
./out/hello
```
On windows, if you have the MinGW bin directory on your path variable then you should be able to use the GNU Linker in command prompt via the 'ld' command as shown in the steps above. You may use the GNU Linker without adding it to your path variable by first opening a terminal in your MinGW's "bin" then specifying the absolute path to the input files and output directory.
```bash
# Windows example for using 'ld' without having it set in the PATH variable
# Active directory is MinGW\bin
.\ld "C:\NASM-samples\samples\1-Hello-World\src\hello.asm" -o "C:\NASM-samples\samples\1-Hello-World\out\hello.exe"
```
# Getting NASM 
## Linux
Install the 'nasm' package using your distribution's package manager. Example for Debian distrubutions:
```bash
sudo apt install nasm
```
## MacOS
Install via Homebrew as follows:
```bash
brew install nasm
```
## Windows
You can download an installer for NASM from: https://www.nasm.us/

# Useful resources
1. X86_64 NASM Assembly Quick Reference - https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html
2. NASM Tutorial - https://cs.lmu.edu/~ray/notes/nasmtutorial/
3. Assembly Variables - https://www.tutorialspoint.com/assembly_programming/assembly_variables.htm
4. Working with Arrays in x86 NASM - https://cratecode.com/info/x86-nasm-assembly-array-manipulation
5. Debugging assembly with GDB - https://ncona.com/2019/12/debugging-assembly-with-gdb/
6. NASM Manual - https://www.cs.uaf.edu/2001/fall/cs301/nasmdoc0.htm
