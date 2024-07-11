# HDL FOLDER
## Contains all hdl IP needed for Murax

### FOLDERS
  - ace_vexriscv_murax, contains fusesoc project.
  - build, when created, contains fusesoc build output.
  - ip_git, contains fusesoc IP cores that come from github repositories.
  - util_pub, contains fusesoc cores that help in code generation.
  - sim_pub, contains fusesoc cores that help in simulating cores.
  - ip_pub, contains public facing IP cores.

### FILES
  - makefile, calls fusesoc and executes build.
  - fusesoc.conf, defines fusesoc library paths.
