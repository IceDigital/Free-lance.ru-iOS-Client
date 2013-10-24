//
//  IDDialogCell.h
//  FLClient
//
//  Created by vitramir on 16.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsImageView;

@interface IDDialogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet AsImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@end
