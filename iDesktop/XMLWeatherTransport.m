//
//  XMLWeatherTransport.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLWeatherTransport.h"
#import "WeatherTransportDelegate.h"

@implementation XMLWeatherTransport

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        delegate = NULL;
    }
    
    return self;
}

- (NSString *)createRequestURL:(WeatherRequest*)request
{
    // Must be overriden in derived classes
    return nil;
}

- (NSURLRequest*)createRequest:(WeatherRequest*)weatherRequest
{
    NSString *sRequest = [self createRequestURL:weatherRequest];
    if (sRequest == NULL)
        return NULL;
    NSString *sURL = [sRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:sURL];
    if (url == NULL)
        return NULL;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [sRequest release];
    return request;
}

- (void) loadForecast:(WeatherRequest*)request delegate:(id<WeatherTransportDelegate>)client
{
    delegate = client;
    
    NSURLRequest *urlRequest = [self createRequest:request];
    if (urlRequest == NULL)
    {
        [delegate transport:self didFailWithError:[NSError errorWithDomain:@"transport" code:-1 userInfo:nil]];
        return;
    }
    responseData = [[NSMutableData data] retain];
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (connection == nil)
    {
        [delegate transport:self didFailWithError:[NSError errorWithDomain:@"transport" code:-1 userInfo:nil]];
        return;        
    }
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [connection release];
    [responseData release];
    
    [delegate transport:self didFailWithError:error];
}

- (WeatherForecast *) parseWeatherXML:(NSXMLParser*)parser
{
    // don't know how to parse
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    // parse the response
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
    WeatherForecast *forecast = [self parseWeatherXML:parser];
    [delegate transport:self didLoadForecast:forecast];
    [parser release];
    
    // release the connection and data buffer
    [connection release];
    connection = nil;
    [responseData release];
    responseData = nil;
}

@end
