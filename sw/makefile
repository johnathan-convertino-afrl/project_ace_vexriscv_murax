SRCDIR	= $(shell pwd)
BINDIR	= bin
OPENOCD_BIN 	= $(SRCDIR)/$(BINDIR)/openocd/bin/openocd
RISV32_BIN	= $(SRCDIR)/$(BINDIR)/riscv/bin/riscv32-unknown-elf-gcc

.PHONY: clean

all: $(OPENOCD_BIN) hello_world

hello_world: $(RISV32_BIN)
	$(MAKE) RISCV_PATH=$(SRCDIR)/$(BINDIR)/riscv -C murax/hello_world/

$(OPENOCD_BIN):
	bash -c "cd openocd_riscv && ./bootstrap"
	bash -c "cd openocd_riscv && ./configure --prefix=$(SRCDIR)/$(BINDIR)/openocd --enable-ftdi --enable-dummy --enable-jtag_vpi"
	$(MAKE) -C openocd_riscv
	$(MAKE) install -C openocd_riscv

$(RISV32_BIN):
	bash -c "cd riscv-gnu-toolchain && ./configure --prefix=$(SRCDIR)/$(BINDIR)/riscv --disable-linux --with-arch=rv32imazicsr --with-abi=ilp32"
	$(MAKE) -C riscv-gnu-toolchain

clean:
	$(MAKE) $@ -C murax/hello_world/
	$(MAKE) $@ -C openocd_riscv/
	$(MAKE) $@ -C riscv-gnu-toolchain/
	rm -rf $(BINDIR)
