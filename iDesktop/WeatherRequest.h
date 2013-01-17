//
//  WeatherRequest.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherRequest : NSObject

@property (copy) NSString *zipCode;
@property (copy) NSString *city;

@end
