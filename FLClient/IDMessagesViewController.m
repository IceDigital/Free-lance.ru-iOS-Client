//
//  IDMessagesViewController.m
//  FLClient
//
//  Created by vitramir on 13.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDMessagesViewController.h"

@interface IDMessagesViewController ()

@end

@implementation IDMessagesViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.refreshControl addTarget:self action:@selector(StartRefreshing:) forControlEvents:UIControlEventValueChanged];
	firstAppear=YES;
	
	self.BubbleData=[NSMutableArray new];
	
	self.tableView.bubbleDataSource=self;
	self.tableView.delegate=self.tableView;
	self.tableView.dataSource=self.tableView;
	
	[self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
	if(firstAppear)
	{
		avFirstRefresh=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.tableView.center.x-18, self.tableView.center.y-18, 37, 37)];
		avFirstRefresh.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
		avFirstRefresh.color=[UIColor grayColor];
		[avFirstRefresh startAnimating];
		[self.tableView addSubview:avFirstRefresh];
		
		[self StartRefreshing:self.refreshControl];
		firstAppear=NO;
	}
}

-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addBubblesFromArray:(NSArray *)data
{
	for (NSDictionary * message in data) {
		int type=BubbleTypeMine;
		NSString * text=message[@"text"];
		if([text isKindOfClass:[NSNull class]])text=@"<Файл в приложении>";
		if([message[@"login"] isEqualToString:self.Login])type=BubbleTypeSomeoneElse;
		NSBubbleData * bubbleMessage=[NSBubbleData dataWithText:text
														   date:[NSDate dateWithTimeIntervalSince1970:[message[@"date"] intValue]]
														   type:type];
        bubbleMessage.links=message[@"links"];
		[self.BubbleData addObject:bubbleMessage];
	}
}

#pragma mark - Refresh messages

-(void)StartRefreshing:(UIRefreshControl *)refreshControl
{
	Loading=YES;
	[self performSelectorInBackground:@selector(RefreshMessages) withObject:nil];
}

-(void)RefreshMessages
{
	NSDictionary * response=[IDData GetMessageForUser:self.Login FromPage:1];
	switch ([response[@"status"] intValue]) {
		case IDResposeOK:
			[self performSelectorOnMainThread:@selector(RefreshMessagesSuccess:)
								   withObject:response
								waitUntilDone:NO];
			break;
		case IDResponseBadToken:
			[self performSelectorOnMainThread:@selector(BadToken) withObject:nil waitUntilDone:NO];
			break;
		case IDResponseBadRequest:
			[self performSelectorOnMainThread:@selector(RefreshMessagesFail) withObject:nil waitUntilDone:NO];
			break;
	}
	Loading=NO;
	[avFirstRefresh removeFromSuperview];
}


-(void)RefreshMessagesSuccess:(NSDictionary *)data
{
    nextPageAvailable=[data[@"next_page"] boolValue];
	[self.BubbleData removeAllObjects];
	[self addBubblesFromArray:data[@"data"]];
	PagesLoaded=1;
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

-(void)RefreshMessagesFail
{
	NSLog(@"refresh fail");
	[self.refreshControl endRefreshing];
}


#pragma mark - Load next page

-(void)StartLoadingNextPage
{
	Loading=YES;
	[self addNextPageLoadingView];
	[self performSelectorInBackground:@selector(LoadNextPage) withObject:nil];
}

-(void)LoadNextPage
{
	NSDictionary * response=[IDData GetMessageForUser:self.Login FromPage:PagesLoaded+1];
	switch ([response[@"status"] intValue]) {
		case IDResposeOK:
			[self performSelectorOnMainThread:@selector(LoadNextPageSuccess:)
								   withObject:response[@"data"]
								waitUntilDone:NO];
			break;
		case IDResponseBadToken:
			[self performSelectorOnMainThread:@selector(BadToken) withObject:nil waitUntilDone:NO];
			break;
		case IDResponseBadRequest:
			[self performSelectorOnMainThread:@selector(LoadNextPageFail) withObject:nil waitUntilDone:NO];
			break;
	}
	[vNextPageLoading removeFromSuperview];
	Loading=NO;
}

-(void)LoadNextPageSuccess:(NSMutableArray *)data
{
	PagesLoaded++;
	[self addBubblesFromArray:data];
	[self.tableView reloadData];
}

-(void)LoadNextPageFail
{
	NSLog(@"refresh fail");
}


-(void)BadToken
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Next page loading view

-(void)createNextPageLoadingView
{
	vNextPageLoading=[UIView new];
	UIActivityIndicatorView * activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activity startAnimating];
	activity.frame=CGRectMake(220, 12, 20, 20);
	
	UILabel * label=[UILabel new];
	label.font=[UIFont systemFontOfSize:12];
	label.frame=CGRectMake(80, 12, 130, 20);
	label.text=@"Следующая страница";
	
	[vNextPageLoading addSubview:activity];
	[vNextPageLoading addSubview:label];
}

-(void)addNextPageLoadingView
{
	if(vNextPageLoading==nil)
	{
		[self createNextPageLoadingView];
	}
	vNextPageLoading.frame=CGRectMake(0, self.tableView.contentSize.height, 320, 44);
	self.tableView.contentInset=UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, 44, self.tableView.contentInset.right);
	[self.tableView addSubview:vNextPageLoading];
}

-(void)removeNextPageLoadingView
{
	[vNextPageLoading removeFromSuperview];
	self.tableView.contentInset=UIEdgeInsetsMake(self.tableView.contentInset.top, self.tableView.contentInset.left, 0, self.tableView.contentInset.right);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if(!Loading && PagesLoaded>0 && nextPageAvailable)
	{
		if(scrollView.contentSize.height-scrollView.frame.size.height-scrollView.contentOffset.y<1000)
		{
			[self StartLoadingNextPage];
		}
	}
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        IDNewMessageController * newMessageViewController=(IDNewMessageController*)(((UINavigationController *)segue.destinationViewController).topViewController);
        newMessageViewController.Login=self.Login;
    }
    else if([segue.destinationViewController isKindOfClass:[IDLinksViewController class]])
    {
        IDLinksViewController * newLinksViewController=(IDLinksViewController *)segue.destinationViewController;
        newLinksViewController.links=selectedLinks;
    }
}

#pragma mark - Table view data source

-(NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
	return [self.BubbleData count];
}

-(NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
	return self.BubbleData[row];
}


-(void)messageRowSelected:(int)row
{
    selectedLinks=((NSBubbleData *)self.BubbleData[row]).links;
    if([selectedLinks count]>0)
    {
        [self performSegueWithIdentifier:@"OpenLinksController" sender:self];
    }
}

@end
