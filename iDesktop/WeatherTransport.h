//
//  WeatherTransport.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherRequest;
@protocol WeatherTransportDelegate;

@protocol WeatherTransport <NSObject>

/** Loads forecast for the specified weather request. */
- (void) loadForecast:(WeatherRequest*)request delegate:(id<WeatherTransportDelegate>)delegate;

@end
