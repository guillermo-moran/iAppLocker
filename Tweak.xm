#import <UIKit/UIKit.h>

static BOOL authenticated = NO;
static UIAlertView *passwordAlert = nil;
static NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.gmoran.iapplockersettings.plist"];
static UITextField *passwordField = [passwordAlert textFieldAtIndex:0];
static NSString *setPassword = [dict objectForKey:@"Password"];

@interface SBApplicationIcon : NSObject <UITextFieldDelegate>
- (id)displayName;
- (id)leafIdentifier;
- (void)launch;
@end


%hook SBApplicationIcon

-(void)launch {

	//========================== BEGIN ALERT STUFF HERE ================================//
		
	//=========================== END ALERT STUFF HERE =================================//

	if (authenticated) { 
		
		%orig; 
		authenticated = NO;
	}
	
	else if ([[dict objectForKey:@"Enabled"] boolValue]) {
		
		if ([[dict objectForKey:@"Locked"] boolValue]) {
	
			if (!authenticated && [[dict objectForKey:[@"LockedApps-" stringByAppendingString:[self leafIdentifier]]] boolValue]) {
				passwordAlert = [[UIAlertView alloc]
	initWithTitle:@"Authentication Required" message:[NSString stringWithFormat:@"A password is required to launch %@",[self displayName]]
	delegate:self 
	cancelButtonTitle:@"Cancel" 
	otherButtonTitles:@"Launch", nil];
	
	[passwordAlert addTextFieldWithValue:@"" label:@"Password"];
	
	passwordField = [passwordAlert textFieldAtIndex:0];
	passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
	passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
	passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordField.secureTextEntry = YES;
	passwordField.delegate = self;
				[passwordAlert show];
				[passwordAlert release];

			
			
			}
			
			else {
			
			%orig;
			
			}
		}
		else {
			passwordAlert = [[UIAlertView alloc]
	initWithTitle:@"Authentication Required" message:[NSString stringWithFormat:@"A password is required to launch %@",[self displayName]]
	delegate:self 
	cancelButtonTitle:@"Cancel" 
	otherButtonTitles:@"Launch", nil];
	
	[passwordAlert addTextFieldWithValue:@"" label:@"Password"];
	
	passwordField = [passwordAlert textFieldAtIndex:0];
	passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
	passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
	passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordField.secureTextEntry = YES;
	passwordField.delegate = self;
			[passwordAlert show];
			[passwordAlert release];
			
		}
	}
	
	else {
	
		%orig;
	
	}
	
	
	 
}

%new
- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alert == passwordAlert) {
		
		if (buttonIndex == 1) {
		
			if ([passwordField.text isEqualToString:setPassword]) {
				
				authenticated = YES;
				[self launch];
				
			}
			
			else {
				
				UIAlertView *errorAlert = [[UIAlertView alloc]
				initWithTitle:@"Authentication Failed" message:@"Incorrect Password."
				delegate:self 
				cancelButtonTitle:@"OK" 
				otherButtonTitles:nil];
	
				[errorAlert show];
				[errorAlert release];
			
			}
		}
	}
}

%end