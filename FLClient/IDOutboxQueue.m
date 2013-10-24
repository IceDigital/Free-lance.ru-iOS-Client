//
//  IDOutboxQueue.m
//  FLClient
//
//  Created by vitramir on 16.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDOutboxQueue.h"

@implementation IDOutboxQueue

NSMutableArray * Queue;

+(void)enqueueMessage:(NSString *)text To:(NSString *)user
{
	NSMutableDictionary * message=[NSMutableDictionary new];
	[message setObject:text forKey:@"text"];
	[message setObject:user forKey:@"user"];
	[IDOutboxQueue performSelectorInBackground:@selector(sendMessage:) withObject:message];
}

+(void)sendMessage:(NSDictionary *)message
{
	[IDData sendMessage:message[@"text"] ToUser:message[@"user"]];
}

@end
