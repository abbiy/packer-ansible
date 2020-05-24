# Default values.

PACKER_CACHE_DIR ?= ~/packer_cache
TEMPLATE_FILE ?= template-centos-7.json
TIMESTAMP := $(shell date +%s)
PLATFORM_VAR_FILE ?= vars/centos-07.06.json
CUSTOM_VAR_FILE ?= vars/custom-template.json

# -----------------------------------------------------------------------------
# The first "make" target runs as default.
# -----------------------------------------------------------------------------

.PHONY: help
help:
	@echo "Perform a Packer build."
	@echo 'Usage:'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] [PLATFORM_VAR_FILE=$(PLATFORM_VAR_FILE)] [CUSTOM_VAR_FILE=$(CUSTOM_VAR_FILE)] <target>'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] [PLATFORM_VAR_FILE=$(PLATFORM_VAR_FILE)] [CUSTOM_VAR_FILE=$(CUSTOM_VAR_FILE)] template-validate'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] [PLATFORM_VAR_FILE=$(PLATFORM_VAR_FILE)] [CUSTOM_VAR_FILE=$(CUSTOM_VAR_FILE)] template-debug'
	@echo '  make [TEMPLATE_FILE=$(TEMPLATE_FILE)] template-format    # Warning: After formatting, variables need to be moved to top of $(TEMPLATE_FILE)'
	@echo
	@echo 'Where:'
	@echo '  target = amazon-ebs, virtualbox-iso, or vmware-iso'
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

# -----------------------------------------------------------------------------
# Utility targets.
# -----------------------------------------------------------------------------

.PHONY: make-packer-cache-dir
make-packer-cache-dir:
	mkdir -p $(PACKER_CACHE_DIR)

# -----------------------------------------------------------------------------
# Build specific images.
# -----------------------------------------------------------------------------

.PHONY: amazon-ebs
amazon-ebs:
	packer build -only=amazon-ebs -var-file $(PLATFORM_VAR_FILE) -var-file $(CUSTOM_VAR_FILE) $(TEMPLATE_FILE)


.PHONY: vmware-iso
vmware-iso: make-packer-cache-dir
	PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) packer build -only=vmware-iso -var-file $(PLATFORM_VAR_FILE) -var-file $(CUSTOM_VAR_FILE) $(TEMPLATE_FILE)


.PHONY: virtualbox-iso
virtualbox-iso: make-packer-cache-dir
	PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) packer build -only=virtualbox-iso -var-file $(PLATFORM_VAR_FILE) -var-file $(CUSTOM_VAR_FILE) $(TEMPLATE_FILE)

# -----------------------------------------------------------------------------
# Utility targets
# -----------------------------------------------------------------------------

.PHONY: template-debug
template-debug:
	packer console -var-file $(PLATFORM_VAR_FILE) -var-file $(CUSTOM_VAR_FILE) $(TEMPLATE_FILE)


.PHONY: template-format
template-format:
	mv $(TEMPLATE_FILE) $(TEMPLATE_FILE).$(TIMESTAMP)
	packer fix $(TEMPLATE_FILE).$(TIMESTAMP) > $(TEMPLATE_FILE)


.PHONY: template-validate
template-validate:
	packer validate -var-file $(PLATFORM_VAR_FILE) -var-file $(CUSTOM_VAR_FILE) $(TEMPLATE_FILE)

# -----------------------------------------------------------------------------
# Clean up targets.
# -----------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -rf output-*
	rm *.box
