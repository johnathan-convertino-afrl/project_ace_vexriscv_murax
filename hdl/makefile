TARGET	= nexys-a7-100t
SRCDIR	= $(shell pwd)
SRC 	= $(shell find $(SRCDIR) -name '*.v')
BITDIR  = $(SRCDIR)/build/AFRL_project_ace_vexriscv_murax_1.0.0/$(TARGET)-vivado/
BIT	= AFRL_project_ace_vexriscv_murax_1.0.0.bit

.PHONY: clean

all: $(BITDIR)$(BIT)

$(BITDIR)$(BIT): $(SRC)
	fusesoc run --target $(TARGET) --build AFRL:project:ace_vexriscv_murax:1.0.0

clean:
	rm -rf build
