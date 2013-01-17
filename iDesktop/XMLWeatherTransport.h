//
//  XMLWeatherTransport.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherTransport.h"

@class WeatherRequest;
@class WeatherForecast;
@protocol WeatherTransportDelegate;

@interface XMLWeatherTransport : NSObject <WeatherTransport>
{
    id<WeatherTransportDelegate> delegate;
    NSURLConnection *connection;
    NSMutableData *responseData;
}

/** Builds url for the given request. */
- (NSString *)createRequestURL:(WeatherRequest*)request;
- (WeatherForecast *) parseWeatherXML:(NSXMLParser*)parser;

@end
