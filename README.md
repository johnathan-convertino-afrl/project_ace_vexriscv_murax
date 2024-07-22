
# HOW TO... Install, Setup, and Test Vexriscv Murax CPU
##  Target: Nexys A7-100T(DDR)

---

  author: Jay Convertino

  date: 08/02/2024

---

!!! Sim, and Lattice targets are NOT part of the make file build system at the moment !!!
  - FUTURE: Change to python build system

This how-to will explain the steps needed to setup and execute the FPGA build
system and sofware build system in this repository. All systems use a series of
makefiles to call the individual build methods. The hdl folder contains all
FPGA code required, and a make file to launch builds. The sw folder contains all
source code and tools. It also has its own make file to launch builds.

Results:

* Vexriscv Murax CPU with RAM, UART, PMP, and GPIO built in. Targeting the Nexys A7-100T FPGA board.
  * future lattice target, added and ready but NOT part of make build system.
  * future sim target, added and ready but NOT part of make build system.
* openocd tool for Vexriscv CPU
* riscv 32bit gcc compiler
* hello_world application for Vexriscv that will use the UART and GPIO.

In this guide I will use the command line exclusively.

Requirements:

  * Ubuntu 20.04 or greater.
  * Vivado 2022.2.2 or greater.
  * Fusesoc 2.4 or greater.
  * sbt version 1.9.8
  * Java version 17.X
  
  <div style="page-break-after: always;"></div>

### Document Version
* v0.0.0 - 08/02/24 - Initial document, needs testing.

#### Document History
* NONE

  <div style="page-break-after: always;"></div>

#### Folders
  * cfg, contains openocd configurations.
  * deps, contains binaries needed for build.
  * hdl, contains IP cores for FPGA fusesoc build system.
    * hdl/build/AFRL_project_ace_vexriscv_murax_1.0.0/nexys-a7-100t-vivado/ contains the vivado project files.
  * log, created during build to contain log files.
  * sw, contains software and tools for Murax CPU.

### Files
  * makefile, executes makefiles in hdl/sw. Targets: hdl, sw, all, clean
  * quiet.mk, Orinally Analog Devices macros to cleanup terminal during build.

### Table of Contents
0.  [Setup_Nexys](#Setup-Nexys)
1.  [Setup Ubuntu packages](#Setup-Ubuntu-Packages)
2.  [Install_sbt_tool](#Install-sbt-tool)
3.  [Vivado](#Vivado)
4.  [Setup_local_PATH](#Setup-local-PATH)
5.  [Execute Build](#Execute-Build)
6.  [Connect with openocd](#Connect-with-openocd)
7.  [Using gdb](#Using-gdb)
8.  [Possible Issues](#Possible-Issues)

  <div style="page-break-after: always;"></div>

 
### Setup Nexys

1. Set JP1 (MODE) to JTAG (jumper connects middle two pins).
2. Set JP2 to USB (jumper connects bottom two pins).
3. Set JP3 to USB (jumper connects left two pins).
4. Connect micro USB cable to PROG/UART terminal.
5. Set power switch to the ON position (up).

  <div style="page-break-after: always;"></div>

### Setup Ubuntu Packages

1. In a terminal, enter the following command to install required packages:

      ```
sudo apt-get install build-essential python3-pip python-is-python3 \
autoconf automake autotools-dev libmpc-dev libmpfr-dev gawk bison flex \
texinfo gperf libtool patchutils ninja-build git cmake libglib2.0-dev \
libusb-1.0-0-dev libusb-dev libyaml-dev libncurses5 libtinfo5 \
openjdk-17-jre-headless minicom putty
      ```

      - The above will install all the needed dependencies in Ubuntu

2. Next enter the command below to install python required packages:

      ```
pip install GitPython fusesoc
      ```
      - The above will install the fusesoc hdl build system.

    <div style="page-break-after: always;"></div>

### Install sbt tool

0. Launch your file manager (nautilus) and navigate to the ace_vexriscv_murax folder.
1. In the root of the ace_vexriscv_murax folder navigate to the deps folder.
2. Enter the folder and look for the tar file `sbt.tar.gz`
3. Launch a terminal by right clicking in the folder and selecting `launch in terminal`.
    - Or navigate using cd command in terminal.
4. Extract `sbt.tar.gz` to your user .local/bin folder using the following command.

      ```
tar -zxf sbt.tar.gz -C ~/.local/ --strip-components=1
      ```
      - The above will extract sbt to the local bin folder where fusesoc resides.

  <div style="page-break-after: always;"></div>

### Vivado

1. If Vivado is not installed, download and follow the instructions to install Vivado only. Vitis is not needed.
2. Install location does not matter, but Vivado install is performed by the local user NOT root.
3. The apt-get command in `Install Ubuntu Packages` takes care of the needed dependencies for Vivado, you're welcome.

  <div style="page-break-after: always;"></div>

### Setup local PATH

1. In a terminal, execute the following to start editing the user bashrc.

    ```
nano ~/.bashrc
    ```

2. In nano add the following lines to bashrc

    ```
PATH=/home/$USER/.local/bin/:$PATH
PATH=/your/path/to/vivado/bin/:$PATH
    ```

3. Save file and exit nano.
4. Execute source command if using same terminal session to kick-off build.

    ```
source ~/.bashrc
    ```

  <div style="page-break-after: always;"></div>

### Execute Build

0. Launch your file manager (nautilus) and navigate to the ace_vexriscv_murax folder.
    - Launch a terminal by right clicking in the folder and selecting `launch in terminal`.
1. In a terminal set to the root of the ace_vexriscv_murax folder kick-off the build.

    ```
make
    ```
    - Build will automaticaly start with the HDL and software builds if using -j option >= 2.
    - A new directory named `log` will be created to store log files.
    - hdl.log will contain all information about the Nexys build.
    - sw.log will contain all information about the software builds.
    - Use -j$(($(nproc)/2)) or -j$(nproc) to speed up riscv gcc build. THIS MAY BREAK UBUNTU ON LOW POWER MACHINES.

    <div style="page-break-after: always;"></div>

### Connect with openocd

0. Launch your file manager (nautilus) and navigate to the ace_vexriscv_murax folder.
    - Launch a terminal by right clicking in the folder and selecting `launch in terminal`.
1. In a terminal set to the root of the ace_vexriscv_murax execute openocd to upload the bitfile over JTAG.

    ```
./sw/bin/openocd/bin/openocd -c \
"set BIT_FILE hdl/build/AFRL_project_ace_vexriscv_murax_1.0.0/nexys-a7-100t-vivado/\
AFRL_project_ace_vexriscv_murax_1.0.0.bit" -f cfg/usb_program.cfg
    ```
    - When the above is finished, the DONE led will be illuminated.
    - This will NOT work for the Lattice design, use openFPGAloader for Lattice.

2. Connect using openocd over JTAG to start a debug server
    A.  Nexys
        - If the below is succesful, there will be no error messages in the openocd terminal.
        - Do not exit, this needs to be running for gdb to connect to.

    ```
./sw/bin/openocd/bin/openocd -c \
"set CPU0_YAML hdl/ip_git/VexRiscv_fusesoc/cores/ace_murax/cpu0.yaml" \
-f cfg/usb_connect.cfg -f cfg/soc_init.cfg
    ```


    B. Lattice, using Altera USB Blaster
        - If the below is succesful, there will be no error messages in the openocd terminal.
        - Do not exit, this needs to be running for gdb to connect to.
        - FUTURE: THERE IS A JTAG IP CORE, NEXT VERSION WILL BE THE SAME AS NEXYS.
        - FUTURE: UART IS BROKEN AT THE MOMENT, JTAG AND UART WILL BE FIXED IN NEXT RELEASE.

    ```
./sw/bin/openocd/bin/openocd -c \
"set CPU0_YAML hdl/ip_git/VexRiscv_fusesoc/cores/ace_murax/cpu0.yaml" \
-f cfg/altera_usb_connect.cfg -f cfg/soc_init_direct.cfg
    ```

  <div style="page-break-after: always;"></div>

### Using gdb

1. In a seperate terminal, at the root of ace_vexriscv_murax, execute gdb.

    ```
./sw/bin/riscv/bin/riscv32-unknown-elf-gdb
    ```

2. Connect to the openocd server.

    ```
target remote localhost:3333
    ```

3. Now load the elf file to the RAM of the Vexriscv CPU

    ```
load sw/murax/hello_world/build/hello_world.elf
    ```

4. In a seperate terminal setup a minicom connection to the UART.

    ```
minicom -b 115200 -D /dev/ttyUSB1
    ```
    - Warning defaults to hardware flow control. Set to no flow control (ctrl+a, z, o, `serial port setup`, f to toggel hardware flow control, esc to exit).
    - Putty is easier for those not used to the command line.

5. Start execution of the application on the Vexriscv.

    ```
continue
    ```
    - The uart will print a hello world message.
    - LEDs will be on above the slide switches.
    - This will last for a few seconds
    - LEDs will change there state based upon slide switch position.
    - The UART will print ASCII characters repeatedly.
    - Each slide switch will set the LED above it on or off based on its position.

  <div style="page-break-after: always;"></div>

### Possible Issues

1. Permissions
    - If you can not connect to the JTAG or UART devices make sure your user is part of the dialout group.

    ```
sudo usermod -a -G dialout $USER
    ```

2. Digilent JTAG drivers
    - You may or may not need to install the udev files for the JTAG device. Follow the Digilent guide to do this.

      [Digilent JTAG guide](https://digilent.com/reference/programmable-logic/guides/install-cable-drivers)

3. Can't connect, JTAG device busy.
    - Disconnect Vivado or any other application using the JTAG device.

4. Can't find INSERT NAME HERE
    - Triple check your paths are set in bashrc. Login and logout of your current session. Then try executing vivado, sbt, and fusesoc from the terminal with no path.
