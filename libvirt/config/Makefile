HOST=

ifndef HOST
$(error hostname must be defined using HOST=hostname)
endif

BASE_IMG=Fedora-Cloud-Base-33-1.2.x86_64.qcow2

VMS=$(PWD)
CONFIG=$(realpath $(VMS)/../config)
IMAGES=$(realpath $(VMS)/../images)

DIR=$(VMS)/$(HOST)
DRIVE=$(DIR)/drive.qcow2
BASE_IMG_PATH=$(shell realpath --relative-to $(DIR) $(IMAGES)/$(BASE_IMG))
SEED=$(DIR)/seed.iso
CONFIG_XML=$(DIR)/$(HOST).xml

all: $(DRIVE) $(SEED) $(CONFIG_XML)

$(DIR):
	mkdir $@

$(DRIVE): | $(DIR)
	qemu-img create -f qcow2 -b $(BASE_IMG_PATH) $@ 20G

$(SEED): | $(DIR)
	$(CONFIG)/seed.sh $(HOST) $@

$(CONFIG_XML): | $(DIR)
	sed -e 's|@host|$(HOST)|' \
		-e 's|@drive|$(realpath $(DRIVE))|' \
		-e 's|@seed|$(realpath $(SEED))|' \
		$(CONFIG)/template.xml > $@
