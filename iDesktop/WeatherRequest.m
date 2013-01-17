//
//  WeatherRequest.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherRequest.h"

@implementation WeatherRequest

@synthesize zipCode;
@synthesize city;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
