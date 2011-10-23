#import <UIKit/UIKit.h>

static BOOL authenticated = NO;
static BOOL isAtSwitcher = NO;

static UIAlertView *passwordAlert = nil;
static NSMutableDictionary *dict = nil;
static UITextField *passwordField = [passwordAlert textFieldAtIndex:0];

static id arg = nil;

@interface SBApplicationIcon : NSObject {}
+ (id)alloc;
- (id)initWithApplication:(id)application;
- (id)displayName;
- (id)leafIdentifier;
@end

@interface SBUIController : NSObject {}
-(void)activateApplicationAnimated:(id)animated;
-(void)activateApplicationFromSwitcher:(id)switcher;
@end

static void setUpTextFieldForAlertView(id aView) {
	[aView addTextFieldWithValue:nil label:@"password..."];
	
	passwordField = [aView textFieldAtIndex:0];
	passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
	passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
	passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordField.secureTextEntry = YES;
}

%hook SBUIController

-(void)activateApplicationAnimated:(id)animated {
	isAtSwitcher = NO;
	arg = animated;
	
	if (authenticated) { 
		%orig; 
		authenticated = NO;
	}
	
	else if ([[dict objectForKey:@"Enabled"] boolValue]) {
		SBApplicationIcon *icon = [[%c(SBApplicationIcon) alloc] initWithApplication:animated];
		
		passwordAlert = [[[UIAlertView alloc] initWithTitle:@"Authentication Required" message:[NSString stringWithFormat:@"A password is required to launch %@",[icon displayName]] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Launch", nil] autorelease];
		passwordAlert.tag = 7515;
		setUpTextFieldForAlertView(passwordAlert);
		
		if ([[dict objectForKey:@"Locked"] boolValue]) {
			if ([[dict objectForKey:[@"LockedApps-" stringByAppendingString:[icon leafIdentifier]]] boolValue]) {
				[passwordAlert show];
			}
			else { %orig; }
		}
		
		else {
			[passwordAlert show];
		}
	}
	
	else { %orig; }
}

-(void)activateApplicationFromSwitcher:(id)switcher {
	isAtSwitcher = YES;
	arg = switcher;
	
	if (authenticated) { 
		%orig; 
		authenticated = NO;
	}
	
	else if ([[dict objectForKey:@"Enabled"] boolValue]) {
		SBApplicationIcon *icon = [[%c(SBApplicationIcon) alloc] initWithApplication:switcher];
		
		passwordAlert = [[[UIAlertView alloc] initWithTitle:@"Authentication Required" message:[NSString stringWithFormat:@"A password is required to launch %@",[icon displayName]] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Launch", nil] autorelease];
		passwordAlert.tag = 7515;
		setUpTextFieldForAlertView(passwordAlert);
		
		if ([[dict objectForKey:@"Locked"] boolValue]) {
			if ([[dict objectForKey:[@"LockedApps-" stringByAppendingString:[icon leafIdentifier]]] boolValue]) {
				[passwordAlert show];
			}
			else { %orig; }
		}
		
		else {
			[passwordAlert show];
		}
	}
	
	else { %orig; }
}

%new
- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([alert tag] == [passwordAlert tag]) {
		if (buttonIndex == 1) {
			if ([passwordField.text isEqualToString:[dict objectForKey:@"Password"]]) {
				authenticated = YES;
				
				// get back to previous methods
				if (isAtSwitcher) [self activateApplicationFromSwitcher:arg];
				else [self activateApplicationAnimated:arg];
			}
			
			else {
				UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed" message:@"Incorrect Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
			}
		}
	}
}
%end

static void SettingsChanged() {
	if (dict != nil) { [dict release]; dict = nil; }
	
	dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.gmoran.iapplockersettings.plist"];
	if (dict == nil) dict = [[NSMutableDictionary alloc] init];
}

%ctor {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	%init;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)&SettingsChanged, CFSTR("com.gmoran.iapplockersettings.updated"), NULL, CFNotificationSuspensionBehaviorHold);
	SettingsChanged();
	[p drain];
}