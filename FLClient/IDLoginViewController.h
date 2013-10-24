//
//  IDViewController.h
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDData.h"

@interface IDLoginViewController : UIViewController
{
	float keyboardHeight;
	float keyboardAnimationDuration;
	BOOL firstAppear;
}

@property (weak, nonatomic) IBOutlet UITextField *tfLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnEnter;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;
@property (weak, nonatomic) IBOutlet UISwitch *schRememberMe;

+(void)clearSession;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *marginBottom;
@property (weak, nonatomic) IBOutlet UIView *vLoginForm;

@end
