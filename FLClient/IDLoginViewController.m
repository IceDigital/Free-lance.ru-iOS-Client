//
//  IDViewController.m
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDLoginViewController.h"

@interface IDLoginViewController ()

@end

@implementation IDLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	keyboardHeight=0;
	firstAppear=YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
	[self setLoginFormPositionAnimated:NO];
	if(firstAppear)
	{
		[self.tfLogin becomeFirstResponder];
		[self autoLogin];
		firstAppear=NO;
	}
}

-(void)autoLogin
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber * remember=[defaults objectForKey:@"remember"];
	NSMutableString * Session=[defaults objectForKey:@"session"];
	NSMutableString * ID=[defaults objectForKey:@"id"];
	NSMutableString * Name=[defaults objectForKey:@"name"];
	NSMutableString * PWD=[defaults objectForKey:@"pwd"];
	
	
	if(remember!=nil && Session!=nil);
	{
		[self.schRememberMe setOn:[remember boolValue]];
		if([remember boolValue])
		{
			[IDData setSession:Session];
			[IDData setName:Name];
			[IDData setID:ID];
			[IDData setPWD:PWD];
			[self LoginSuccess];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)SetControlsState:(BOOL)state
{
	[UIView beginAnimations:@"enter" context:nil];
	[UIView setAnimationDuration:0.3];
	
	self.btnEnter.alpha=state;
	self.btnCancel.alpha=!state;
	self.avLoading.alpha=!state;
	
	[UIView commitAnimations];
}

-(void)LoginCanceled
{
	[self SetControlsState:YES];
}

-(void)LoginSuccess
{
	if(self.schRememberMe.on)
	{
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:[NSNumber numberWithBool:YES] forKey:@"remember"];
		[defaults setObject:[IDData getSession] forKey:@"session"];
		[defaults setObject:[IDData getName] forKey:@"name"];
		[defaults setObject:[IDData getPWD] forKey:@"pwd"];
		[defaults setObject:[IDData getID] forKey:@"id"];
		[defaults synchronize];
	}
	else
	{
		[IDLoginViewController clearSession];
	}
	
	[self performSegueWithIdentifier:@"OpenDialogsViewController" sender:self];
	[self SetControlsState:YES];
}

+(void)clearSession
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:@"remember"];
	[defaults setObject:@"" forKey:@"session"];
	[defaults synchronize];
}

-(void)LoginFailed
{
	[self SetControlsState:YES];
}

- (IBAction)btnEnter_TouchUpInside:(id)sender {
	[self SetControlsState:NO];
	[self performSelectorInBackground:@selector(Login) withObject:nil];
}

-(void)Login
{
	if([IDData AuthWithLogin:self.tfLogin.text andPassword:self.tfPassword.text andRememberMe:self.schRememberMe.on])
	{
		[self performSelectorOnMainThread:@selector(LoginSuccess) withObject:nil waitUntilDone:NO];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(LoginFailed) withObject:nil waitUntilDone:NO];
	}
}

- (IBAction)btnCancel_TouchUpInside:(id)sender {
	[self LoginCanceled];
}

-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
	keyboardHeight = keyboardFrame.size.height;
	keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	[self setLoginFormPositionAnimated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight=0;
	
	[self setLoginFormPositionAnimated:YES];
}

-(void)setLoginFormPositionAnimated:(BOOL)animated
{
	float fullSize=self.view.frame.size.height-self.vLoginForm.frame.size.height;
	float halfMargin=(fullSize-keyboardHeight)/2.0;
	self.marginTop.constant=halfMargin;
	self.marginBottom.constant=halfMargin+keyboardHeight;
	
	if(animated)
	{
		[UIView beginAnimations:@"keyboard" context:nil];
		[UIView setAnimationDuration:keyboardAnimationDuration];
	}
	
	[self.view layoutIfNeeded];
	
	if(animated)
	{
		[UIView commitAnimations];
	}
}

@end
