//
//  WeatherTransportDelegate.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherTransport;
@class WeatherForecast;

@protocol WeatherTransportDelegate <NSObject>

- (void) transport:(id<WeatherTransport>)transport didLoadForecast:(WeatherForecast*)forecast;
- (void) transport:(id<WeatherTransport>)transport didFailWithError:(NSError*)error;

@end
