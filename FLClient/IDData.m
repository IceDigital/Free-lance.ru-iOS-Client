//
//  IDData.m
//  FLClient
//
//  Created by vitramir on 12.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDData.h"

@implementation IDData

NSMutableString * Session;
NSMutableString * Name;
NSMutableString * ID;
NSMutableString * PWD;

+(NSString *)getSession
{
	return Session;
}

+(NSString *)getName
{
	return Name;
}

+(NSString *)getID
{
	return ID;
}

+(NSString *)getPWD
{
	return PWD;
}

+(void)setSession:(NSMutableString *)session
{
	Session=session;
}

+(void)setName:(NSMutableString *)name
{
	Name=name;
}

+(void)setID:(NSMutableString *)Id
{
	ID=Id;
}

+(void)setPWD:(NSMutableString *)pwd
{
	PWD=pwd;
}

+(BOOL)AuthWithLogin:(NSString *)login andPassword:(NSString *)password andRememberMe:(BOOL)remember
{
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
	Session=[NSMutableString new];
	Name=[NSMutableString new];
	ID=[NSMutableString new];
	PWD=[NSMutableString new];
	
	
	BOOL state=[IDHttpRequest getSESSIDFromUrl:@"https://www.fl.ru/" andPostData:[NSString stringWithFormat:@"action=login&login=%@&passwd=%@%@",login,password,remember?@"&autologin=1":@""] toSession:Session toID:ID toName:Name toPWD:PWD];

	return state;
}

+(NSDictionary *)GetDialogsFromPage:(int)page
{
	NSString * requestUrl=[NSString stringWithFormat:@"http://free-lance.icedigital.ru/?page=%d&cookie=%@&id=%@&name=%@&pwd=%@",page, Session, ID, Name, PWD];
	NSDictionary * income_data=[IDHttpRequest getObjectFromUrl:requestUrl];
	
	NSMutableDictionary * result=[NSMutableDictionary new];
	NSString * error=income_data[@"error"];
	if(error==nil && income_data!=nil)
	{
		[result setObject:[NSNumber numberWithInt:IDResposeOK] forKey:@"status"];
		[result setObject:income_data[@"data"] forKey:@"data"];
        [result setObject:income_data[@"next_page"] forKey:@"next_page"];
	}
	else
	{
		[result setObject:[NSNumber numberWithInt:IDResponseBadToken] forKey:@"status"];
	}
	return result;
}

+(NSDictionary *)GetMessageForUser:(NSString *)user FromPage:(int)page
{
	NSString * requestUrl=[NSString stringWithFormat:@"http://free-lance.icedigital.ru/?get=%@&page=%d&cookie=%@&id=%@&name=%@&pwd=%@",user,page, Session, ID, Name, PWD];
	NSDictionary * income_data=[IDHttpRequest getObjectFromUrl:requestUrl];
    NSLog(@"%@", income_data);
	
	NSMutableDictionary * result=[NSMutableDictionary new];
	NSString * error=income_data[@"error"];
	if(error==nil && income_data!=nil)
	{
		[result setObject:[NSNumber numberWithInt:IDResposeOK] forKey:@"status"];
		[result setObject:income_data[@"data"] forKey:@"data"];
        if(income_data[@"links"]!=nil)
        {
            [result setObject:income_data[@"links"] forKey:@"links"];
        }
        [result setObject:income_data[@"next_page"] forKey:@"next_page"];
	}
	else
	{
		[result setObject:[NSNumber numberWithInt:IDResponseBadToken] forKey:@"status"];
	}
	return result;
}


+(BOOL)sendMessage:(NSString *)text ToUser:(NSString *)user
{
		NSString* escapedMessage = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)text,NULL,CFSTR("!*'();:@&=+$,/?%#[]\""),kCFStringEncodingUTF8));
	NSString * requestUrl=[NSString stringWithFormat:@"http://free-lance.icedigital.ru/?get=%@&cookie=%@&id=%@&name=%@&pwd=%@&msg=%@",user, Session, ID, Name, PWD,escapedMessage];
	NSDictionary * income_data=[IDHttpRequest getObjectFromUrl:requestUrl];
	if(income_data[@"status"])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}


@end
