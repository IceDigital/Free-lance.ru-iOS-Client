//
//  IDOutboxQueue.h
//  FLClient
//
//  Created by vitramir on 16.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDData.h"

@interface IDOutboxQueue : NSObject

+(void)enqueueMessage:(NSString *)text To:(NSString *)user;

@end
