//
//  IDNewMessageController.m
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDNewMessageController.h"

@interface IDNewMessageController ()

@end

@implementation IDNewMessageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[self.tvNewMessageText becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
	return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
	
    CGFloat height;
	if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
	{
		height = keyboardFrame.size.width;
	}
	else
	{
		height = keyboardFrame.size.height;
	}
	self.cnstrBottomTextView.constant=10+height;
}

- (void)keyboardWillHide:(NSNotification *)notification {
	self.cnstrBottomTextView.constant=10;
}

- (IBAction)btnCancel_Click:(id)sender {
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
	self.cnstrTopBar.constant=22;
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSend_Click:(id)sender {
	[IDOutboxQueue enqueueMessage:self.tvNewMessageText.text To:self.Login];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
