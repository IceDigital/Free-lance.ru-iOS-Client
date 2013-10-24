//
//  IDDialogsViewController.m
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDDialogsViewController.h"
#import "IDLoginViewController.h"

@interface IDDialogsViewController ()

@end

@implementation IDDialogsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.Data=[NSMutableArray new];
	self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
	firstAppear=YES;
	PagesLoaded=0;
	
	[self.refreshControl addTarget:self action:@selector(StartRefreshing:) forControlEvents:UIControlEventValueChanged];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh dialog

-(void)StartRefreshing:(UIRefreshControl *)refreshControl
{
	Loading=YES;
	[self performSelectorInBackground:@selector(RefreshDialogs) withObject:nil];
}

-(void)RefreshDialogs
{
	NSDictionary * response=[IDData GetDialogsFromPage:1];
	switch ([response[@"status"] intValue]) {
		case IDResposeOK:
			[self performSelectorOnMainThread:@selector(RefreshDialogsSuccess:)
								   withObject:response[@"data"]
								waitUntilDone:NO];
			break;
		case IDResponseBadToken:
			[self performSelectorOnMainThread:@selector(BadToken) withObject:nil waitUntilDone:NO];
			break;
		case IDResponseBadRequest:
			[self performSelectorOnMainThread:@selector(RefreshDialogsFail) withObject:nil waitUntilDone:NO];
			break;
	}
	Loading=NO;
	[avFirstRefresh removeFromSuperview];
}

-(void)RefreshDialogsSuccess:(NSMutableArray *)data
{
	[self.Data removeAllObjects];
	[self.Data addObjectsFromArray:data];
	PagesLoaded=1;
	self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}

-(void)RefreshDialogsFail
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
	NSDictionary * response=[IDData GetDialogsFromPage:PagesLoaded+1];
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
	[self.Data addObjectsFromArray:data];
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

- (IBAction)btnExit_Click:(id)sender {
	[IDLoginViewController clearSession];
	[self dismissViewControllerAnimated:YES completion:nil];

}

-(void)viewDidDisappear:(BOOL)animated
{
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
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
	if(!Loading && PagesLoaded>0)
	{
		if(scrollView.contentSize.height-scrollView.frame.size.height-scrollView.contentOffset.y<400)
		{
			[self StartLoadingNextPage];
		}
	}
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	IDMessagesViewController * messagesViewController=(IDMessagesViewController*)segue.destinationViewController;
	messagesViewController.Login=self.Data[self.tableView.indexPathForSelectedRow.row][@"login"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.Data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DialogCell";
    IDDialogCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	[cell.imgAvatar loadFromURLString:self.Data[indexPath.row][@"avatar"]];
	NSString * name=self.Data[indexPath.row][@"name"];
	NSString * sname=self.Data[indexPath.row][@"sname"];
	NSString * login=self.Data[indexPath.row][@"login"];

	if([name isKindOfClass:[NSNull class]])name=@"";
	if([sname isKindOfClass:[NSNull class]])sname=@"";
	cell.lblName.text=[NSString stringWithFormat:@"%@ %@",name,sname];
	
	cell.lblLogin.text=login;
	cell.lblStatus.text=self.Data[indexPath.row][@"status"];
	cell.lblCount.text=[NSString stringWithFormat:@"Сообщений: %d",[self.Data[indexPath.row][@"msgs"] intValue]];
	
	cell.lblName.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
	cell.lblLogin.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14];
	cell.lblCount.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14];
	cell.lblStatus.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:13];
	cell.lblStatus.textAlignment=NSTextAlignmentCenter;
	
	if([self.Data[indexPath.row][@"newmess"] intValue]==1)
	{
		cell.lblStatus.textColor=[UIColor orangeColor];
	}
	else
	{
		cell.lblStatus.textColor=[UIColor darkGrayColor];
	}
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
