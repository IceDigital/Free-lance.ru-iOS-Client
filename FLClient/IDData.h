//
//  IDData.h
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDHttpRequest.h"

typedef enum {IDResposeOK, IDResponseBadToken, IDResponseBadRequest} IDResponseStatus;

@interface IDData : NSObject

+(BOOL)AuthWithLogin:(NSString *)login andPassword:(NSString *)password andRememberMe:(BOOL)remember;
+(NSDictionary *)GetDialogsFromPage:(int)page;
+(NSDictionary *)GetMessageForUser:(NSString *)user FromPage:(int)page;
+(BOOL)sendMessage:(NSString *)text ToUser:(NSString *)user;

+(void)setSession:(NSMutableString *)session;
+(NSMutableString *)getSession;
+(void)setID:(NSMutableString *)Id;
+(NSMutableString *)getID;
+(void)setPWD:(NSMutableString *)pwd;
+(NSMutableString *)getPWD;
+(void)setName:(NSMutableString *)name;
+(NSMutableString *)getName;

@end
