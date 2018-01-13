################################################################################
#
# uxas
#
################################################################################

UXAS_VERSION = 1.0
UXAS_SITE = /src/OpenUxAS
UXAS_SITE_METHOD = local

UXAS_DEPENDENCIES = host-meson host-pkgconf

UXAS_CONF_OPTS += \
	--prefix=/usr \
	--buildtype $(if $(BR2_ENABLE_DEBUG),debug,release) \
	--cross-file $(HOST_DIR)/etc/meson/cross-compilation.conf

UXAS_NINJA_OPTS = $(if $(VERBOSE),-v)

define UXAS_CONFIGURE_CMDS
	rm -rf $(@D)/build_buildroot
	mkdir -p $(@D)/build_buildroot
	$(TARGET_MAKE_ENV) meson $(UXAS_CONF_OPTS) $(@D) $(@D)/build_buildroot
endef

define UXAS_BUILD_CMDS
	$(TARGET_MAKE_ENV) ninja $(UXAS_NINJA_OPTS) -C $(@D)/build_buildroot
endef

define UXAS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(TARGET_DIR) ninja $(UXAS_NINJA_OPTS) \
		-C $(@D)/build_buildroot install
endef

define UXAS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) DESTDIR=$(STAGING_DIR) ninja $(UXAS_NINJA_OPTS) \
		-C $(@D)/build_buildroot install
endef

$(eval $(generic-package))
