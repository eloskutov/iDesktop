//
//  ForecastCondition.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherCondition.h"

@interface ForecastCondition : WeatherCondition

/** Highest temperature for the day in farenheit. */
@property (nonatomic) NSInteger temperatureHigh;
/** Lowest temperature for the day in farenheit. */
@property (nonatomic) NSInteger temperatureLow;

@end
