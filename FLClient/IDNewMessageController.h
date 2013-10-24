//
//  IDNewMessageController.h
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDOutboxQueue.h"

@interface IDNewMessageController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrTopBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrBottomTextView;
@property (weak, nonatomic) IBOutlet UITextView *tvNewMessageText;

@property NSString * Login;

@end
