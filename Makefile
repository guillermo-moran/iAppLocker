THEOS_DEVICE_IP = 192.168.1.102
include theos/makefiles/common.mk

TWEAK_NAME = iAppLocker
iAppLocker_FILES = Tweak.xm
iAppLocker_FRAMEWORKS = UIKit
SUBPROJECTS = iapplockersettings

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
