# CFG FOLDER
## Contains configuration files for openocd

### FILES
  - altera_usb_connect.cfg, use Altera USB Blaster to connect to Murax core over JTAG.
  - soc_init_direct.cfg, for direct JTAG connections to Murax core.
  - soc_init.cfg, will initialize Murax CPU and setup server for telnet and gdb.
  - usb_connect.cfg, setup jtag Nexys (Digilent) connection for soc_init.cfg
  - usb_programm.cfg, same as usb_connect.cfg except it will initialize, and then program the device using the bitfile
    set to bitfile variable.
