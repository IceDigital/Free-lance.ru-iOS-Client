//
//  IDHttpRequest.h
//  FLClient
//
//  Created by vitramir on 15.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDHttpRequest : NSObject<NSURLConnectionDelegate>
{
	NSMutableData * Data;
	NSURLResponse * Response;
	BOOL ended;
}

+(BOOL)getSESSIDFromUrl:(NSString *)url andPostData:(NSString *)post toSession:(NSMutableString *)session toID:(NSMutableString *)ID toName:(NSMutableString *)name toPWD:(NSMutableString*)pwd;
+(id)getObjectFromUrl:(NSString *)url;

@end
