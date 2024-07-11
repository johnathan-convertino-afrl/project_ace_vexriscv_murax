include quiet.mk

SUBPRJ = hdl sw

.PHONY: $(SUBPRJ) clean
.SILENT: clean

all: $(SUBPRJ)

$(SUBPRJ):
	mkdir -p log
	$(call build, $(MAKE) -C $@, log/$(@).log, $@)


clean:
	$(call clean_run, $(foreach prj, $(SUBPRJ), $(MAKE) $@ -C $(prj);), "removing all build results")
	$(call clean, log, "removing all log files")
