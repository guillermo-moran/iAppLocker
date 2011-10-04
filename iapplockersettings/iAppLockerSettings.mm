#import <Preferences/Preferences.h>

@interface iAppLockerSettingsListController: PSListController {
}
@end

@interface AppListController : iAppLockerSettingsListController {
}
@end

@implementation iAppLockerSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"iAppLockerSettings" target:self] retain];
	}
	return _specifiers;
}
@end

@implementation AppListController

- (id)specifiers {
    _specifiers = [[self loadSpecifiersFromPlistName:@"iAppLockerAppList" target:self] retain];
    return _specifiers;
}

@end

// vim:ft=objc
