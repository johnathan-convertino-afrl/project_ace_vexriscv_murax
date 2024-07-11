# SOFTWARE FOLDER
## Contains all software needed for Murax

### FOLDERS
  - openocd_risv, from [github](https://github.com/SpinalHDL/openocd_riscv)
  - riscv-gnu-toolchain, from [github](https://github.com/riscv-collab/riscv-gnu-toolchain)
  - murax, from [github](https://github.com/SpinalHDL/VexRiscv/tree/master/src/main/c/murax/hello_world)
  - bin, created to store binaries fom openocd and riscv-gcc.

### FILES
  - makefile, calls build scripts needed to execute builds.
    - uses target binaries to keep from building needlessly for riscv and openocd. Clean if rebuild needed.
    - murax can only be built with riscv32 and has a hardcode path to bin/riscv/bin
