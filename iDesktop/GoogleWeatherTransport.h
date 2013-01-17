//
//  GoogleWeatherTransport.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLWeatherTransport.h"

@class WeatherForecast;
@class WeatherCondition;
@class CurrentCondition;
@class ForecastCondition;

@interface GoogleWeatherTransport : XMLWeatherTransport <NSXMLParserDelegate>
{
    WeatherForecast *forecast;
    CurrentCondition *currentCondition;
    ForecastCondition *forecastCondition;
    WeatherCondition *activeCondition;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateTimeFormatter;
    NSMutableArray *futureConditions;
    
    NSDate *currentDate;
}
    
@end
