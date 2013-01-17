//
//  WeatherForecast.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherForecast.h"

@implementation WeatherForecast

@synthesize currentCondition;
@synthesize futureConditions;
@synthesize location;
@synthesize observationDate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
