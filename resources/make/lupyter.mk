IPY_CFG_DIR = ~/.ipython
IPY_KERN_DIR = $(IPY_CFG_DIR)/kernels
LUPY_DIR = $(IPY_KERN_DIR)/lupyter
LUPY = ipython-lfe
LUPY_FULL = $(LUPY_DIR)/$(LUPY)
LUPY_JSON = $(LUPY_DIR)/kernel.json

setup: $(LUPY_DIR) $(LUPY_FULL)

$(LUPY_DIR):
	mkdir -p $(LUPY_DIR)

$(LUPY_FULL):
	cp bin/$(LUPY) $(LUPY_FULL)

$(LUPY_JSON):
	sed 's|HOME|'${HOME}'|' resources/kernel.json > $(LUPY_JSON)
