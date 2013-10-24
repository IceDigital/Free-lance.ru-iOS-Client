//
//  IDHttpRequest.m
//  FLClient
//
//  Created by vitramir on 15.06.13.
//  Copyright (c) 2013 IceDigital. All rights reserved.
//

#import "IDHttpRequest.h"

@implementation IDHttpRequest
IDHttpRequest*MAIN;

-(BOOL)getSESSIDFromUrl:(NSString *)url andPostData:(NSString *)post toSession:(NSMutableString *)session toID:(NSMutableString *)ID toName:(NSMutableString *)name toPWD:(NSMutableString*)pwd
{
	NSMutableURLRequest * req=[NSMutableURLRequest new];
	NSMutableData *postData=[NSMutableData data];
	[postData appendData:[post dataUsingEncoding:NSUTF8StringEncoding]];

	[req setURL:[NSURL URLWithString:url]];
	[req setHTTPMethod:@"POST"];
	[req setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[req setHTTPBody:postData];
	
	NSURLConnection * connection=[[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:NO];
	[connection performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
	while(!ended)
	{
		[NSThread sleepForTimeInterval:0.1f];
	}
	NSHTTPURLResponse * response = (NSHTTPURLResponse*)Response;
	if(response!=nil)
	{
		if(![[response allHeaderFields][@"Location"] isEqualToString:@"/remind.php?incorrect_login=1"])
		{
			NSString * cookieString=[response allHeaderFields][@"Set-Cookie"];
			if(cookieString!=nil)
			{
				NSString * paramSession=[self getCookieParameter:@"PHPSESSID" fromCookies:cookieString];
				NSString * paramID=[self getCookieParameter:@"id" fromCookies:cookieString];
				NSString * paramName=[self getCookieParameter:@"name" fromCookies:cookieString];
				NSString * paramPWD=[self getCookieParameter:@"pwd" fromCookies:cookieString];
				
				
				if(paramSession!=nil)[session setString:paramSession];
				if(paramID!=nil)[ID setString:paramID];
				if(paramName!=nil)[name setString:paramName];
				if(paramPWD!=nil)[pwd setString:paramPWD];
				return YES;
			}
		}
	}
	return NO;
}

-(NSString *)getCookieParameter:(NSString *)parameter fromCookies:(NSString *)cookieString
{
	id error=nil;
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@=([a-zA-Z0-9]+)",parameter] options:0 error:&error];
	NSArray* matches = [regex matchesInString:cookieString options:0 range:NSMakeRange(0, [cookieString length])];
	for ( NSTextCheckingResult* match in matches)
	{
		return [cookieString substringWithRange:[match rangeAtIndex:1]];
	}
	return nil;
}


-(id)getDataFromUrl:(NSString *)url
{
    NSLog(@"%@", url);
	NSURLRequest * req=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	NSURLConnection * connection=[[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:NO];
	[connection performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
	while(!ended)
	{
		[NSThread sleepForTimeInterval:0.1f];
	}
	NSData * data = Data;
	
	id error=nil;
	id object = [NSJSONSerialization
				 JSONObjectWithData:data
				 options:0
				 error:&error];
    if(error) { /* JSON was malformed, act appropriately here */ }
	
	return object;
}


+(id)getObjectFromUrl:(NSString *)url
{
	return [[IDHttpRequest new] getDataFromUrl:url];
}

+(BOOL)getSESSIDFromUrl:(NSString *)url andPostData:(NSString *)post toSession:(NSMutableString *)session toID:(NSMutableString *)ID toName:(NSMutableString *)name toPWD:(NSMutableString*)pwd
{
	return [[IDHttpRequest new] getSESSIDFromUrl:url andPostData:post toSession:session toID:ID toName:name toPWD:pwd];
}


-(id)init
{
	self=[super init];
	Data=[NSMutableData new];
	ended=NO;
	
	return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	Response=response;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[Data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	ended=YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	ended=YES;
}


- (NSURLRequest *)connection: (NSURLConnection *)inConnection
             willSendRequest: (NSURLRequest *)inRequest
            redirectResponse: (NSURLResponse *)inRedirectResponse;
{
    if (inRedirectResponse) {
        return nil;
    } else {
        return inRequest;
    }
}

@end
