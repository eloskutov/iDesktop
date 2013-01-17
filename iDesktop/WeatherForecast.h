//
//  WeatherForecast.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CurrentCondition;

/** Weather data. */
@interface WeatherForecast : NSObject

/** Current condition. */
@property (retain) CurrentCondition *currentCondition;
/** List of conditions for future dates (ForecastCondition). */
@property (nonatomic, copy) NSArray *futureConditions;
/** Location the forecast was calculated for. */
@property (copy) NSString *location;
@property (copy) NSDate *observationDate;

@end
