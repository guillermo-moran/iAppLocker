SDKVERSION=4.0
include theos/makefiles/common.mk

BUNDLE_NAME = iAppLockerSettings
iAppLockerSettings_FILES = iAppLockerSettings.mm
iAppLockerSettings_INSTALL_PATH = /Library/PreferenceBundles
iAppLockerSettings_FRAMEWORKS = UIKit
iAppLockerSettings_PRIVATE_FRAMEWORKS = Preferences
GO_EASY_ON_ME = 1
iAppLocker_LDFLAGS = -AppList


include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/iAppLockerSettings.plist$(ECHO_END)
