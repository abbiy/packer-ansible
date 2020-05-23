# Default values.

AWS_FILE ?= vars/aws.json
PACKER_CACHE_DIR ?= ~/packer_cache
TEMPLATE_FILE ?= template-centos.json
TIMESTAMP := $(shell date +%s)
VAR_FILE ?= vars/centos-08.01.json

# -----------------------------------------------------------------------------
# The first "make" target runs as default.
# -----------------------------------------------------------------------------

.PHONY: help
help:
	@echo "Perform a Packer build."
	@echo 'Usage:'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] [VAR_FILE=$(VAR_FILE)] [AWS_FILE=$(AWS_FILE)] amazon-ebs'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] [VAR_FILE=$(VAR_FILE)] {target}'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] template-validate  # Lint $(TEMPLATE_FILE)'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] template-debug     # Inspect $(TEMPLATE_FILE)'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] template-format    # Warning: After formatting, variables need to be moved to top of $(TEMPLATE_FILE)'
	@echo
	@echo 'Where:'
	@echo '  Targets:'
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

# -----------------------------------------------------------------------------
# Utility targets.
# -----------------------------------------------------------------------------

.PHONY: make-packer-cache-dir
make-packer-cache-dir:
	mkdir -p $(PACKER_CACHE_DIR)

# -----------------------------------------------------------------------------
# Build all images.
# -----------------------------------------------------------------------------

.PHONY: all
all: make-packer-cache-dir
	PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) packer build -var-file $(VAR_FILE) -var-file $(AWS_FILE) $(TEMPLATE_FILE)

# -----------------------------------------------------------------------------
# Build specific images.
# -----------------------------------------------------------------------------

.PHONY: amazon-ebs
amazon-ebs:
	packer build -only=amazon-ebs -var-file $(VAR_FILE) -var-file $(AWS_FILE) $(TEMPLATE_FILE)


.PHONY: vmware-iso
vmware-iso: make-packer-cache-dir
	PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) packer build -only=vmware-iso -var-file $(VAR_FILE) $(TEMPLATE_FILE)


.PHONY: virtualbox-iso
virtualbox-iso: make-packer-cache-dir
	PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) packer build -only=virtualbox-iso -var-file $(VAR_FILE) $(TEMPLATE_FILE)

# -----------------------------------------------------------------------------
# Utility targets
# -----------------------------------------------------------------------------

.PHONY: template-debug
template-debug:
	packer console -var-file $(VAR_FILE) -var-file $(AWS_FILE) $(TEMPLATE_FILE)


.PHONY: template-format
template-format:
	mv $(TEMPLATE_FILE) $(TEMPLATE_FILE).$(TIMESTAMP)
	packer fix $(TEMPLATE_FILE).$(TIMESTAMP) > $(TEMPLATE_FILE)


.PHONY: template-validate
template-validate:
	packer validate -var-file $(VAR_FILE) $(TEMPLATE_FILE)

# -----------------------------------------------------------------------------
# Clean up targets.
# -----------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf output-*
	rm *.box
