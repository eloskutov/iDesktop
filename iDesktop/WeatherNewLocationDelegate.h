//
//  WeatherNewLocationDelegate.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherForecast;

@protocol WeatherNewLocationDelegate <NSObject>

- (void) addLocationWithForecast:(WeatherForecast*)forecast;

@end
