//
//  IDMessagesViewController.h
//  FLClient
//
//  Created by vitramir on 13.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDData.h"
#import "NSBubbleData.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "IDNewMessageController.h"
#import "IDLinksViewController.h"

@interface IDMessagesViewController : UITableViewController<UIBubbleTableViewDataSource>
{
	BOOL firstAppear;
	UIActivityIndicatorView * avFirstRefresh;
	BOOL Loading;
	int PagesLoaded;
	UIView * vNextPageLoading;
    BOOL nextPageAvailable;
    
    NSArray * selectedLinks;
}


@property NSString * Login;
@property(nonatomic,retain) UIBubbleTableView *tableView;

@property NSMutableArray * BubbleData;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
-(void)messageRowSelected:(int)row;

@end
