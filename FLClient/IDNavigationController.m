//
//  IDNavigationController.m
//  FLClient
//
//  Created by vitramir on 16.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDNavigationController.h"

@interface IDNavigationController ()

@end

@implementation IDNavigationController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
	return YES;
}

@end
