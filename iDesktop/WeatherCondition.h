//
//  WeatherCondition.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ConditionCode
{
    WeatherPartlySunny,    
    WeatherScatteredThunderstorms,
    WeatherShowers,
    WeatherScatteredShowers,
    WeatherRainAndSnow,
    WeatherOvercast,
    WeatherLightSnow,
    WeatherFreezingDrizzle,
    WeatherChanceOfRain,
    WeatherSunny,
    WeatherClear,
    WeatherMostlySunny,
    WeatherPartlyCloudy,
    WeatherMostlyCloudy,
    WeatherChanceOfStorm,
    WeatherRain,
    WeatherChanceOfSnow,
    WeatherCloudy,
    WeatherMist,
    WeatherStorm,
    WeatherThunderstorm,
    WeatherChangeOfTStorm,
    WeatherSleet,
    WeatherSnow,
    WeatherIcy,
    WeatherDust,
    WeatherFog,
    WeatherSmoke,
    WeatherHaze,
    WeatherFlurries,
    WeatherLightRain,
    WeatherSnowShowers,
    WeatherIceSnow,
    WeatherWindy,
    WeatherScatteredSnowShowers,
};

@interface WeatherCondition : NSObject
    
/** Condition code. */
@property (nonatomic) enum ConditionCode code;
/** Wind direction code (16 point compass). */
@property (copy) NSString *windDirection;
/** Wind speed (miles per hour). */
@property (nonatomic) NSUInteger windSpeed;
/** Precipation in milimetre (-1 means undefined). */
@property (nonatomic) NSInteger precipation;
/** Date the forecast is for. */
@property (copy) NSDate *date;

@end
