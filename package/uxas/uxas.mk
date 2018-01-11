################################################################################
#
# uxas
#
################################################################################

UXAS_VERSION = develop
#UXAS_SOURCE = uxas-$(UXAS_VERSION).tar.gz
UXAS_SITE = $(call github,GaloisInc,OpenUxAS,$(UXAS_VERSION))
UXAS_INSTALL_STAGING = YES

UXAS_DEPENDENCIES = host-meson

UXAS_CONF_OPTS += \
	--prefix=/usr \
	--buildtype $(if $(BR2_ENABLE_DEBUG),debug,release) \
	--cross-file $(HOST_DIR)/etc/meson/cross-compilation.conf

UXAS_NINJA_OPTS = $(if $(VERBOSE),-v)

define UXAS_CONFIGURE_CMDS
	rm -rf $(@D)/build
	mkdir -p $(@D)/build
	$(TARGET_MAKE_ENV) meson $(UXAS_CONF_OPTS) $(@D) $(@D)/build
endef

define UXAS_BUILD_CMDS
	$(TARGET_MAKE_ENV) ninja $(UXAS_NINJA_OPTS) -C $(@D)/build
endef

define UXAS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) ninja $(UXAS_NINJA_OPTS) \
		-C $(@D)/build install
endef

define UXAS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(STAGING_DIR) ninja $(UXAS_NINJA_OPTS) \
		-C $(@D)/build install
endef

$(eval $(generic-package))
