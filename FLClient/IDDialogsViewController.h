//
//  IDDialogsViewController.h
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDData.h"
#import "IDDialogCell.h"
#import "IDMessagesViewController.h"
#import "AsImageView.h"

@interface IDDialogsViewController : UITableViewController
{
	BOOL firstAppear;
	UIActivityIndicatorView * avFirstRefresh;
	UIView * vNextPageLoading;
	int PagesLoaded;
	BOOL Loading;
}

@property NSMutableArray * Data;

@end
