//
//  WeatherCondition.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherCondition.h"


@implementation WeatherCondition

@synthesize date;
@synthesize code;
@synthesize windDirection;
@synthesize windSpeed;
@synthesize precipation;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        code = WeatherSunny;
    }
    
    return self;
}

@end
