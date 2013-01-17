//
//  CurrentCondition.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherCondition.h"

@interface CurrentCondition : WeatherCondition

/** Humidity in percents. */
@property (nonatomic) NSUInteger humidity;
/** Current temperature. */
@property (nonatomic) NSInteger temperature;

@end
