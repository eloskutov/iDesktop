//
//  GoogleWeatherTransport.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoogleWeatherTransport.h"
#import "WeatherRequest.h"
#import "WeatherForecast.h"
#import "WeatherCondition.h"
#import "CurrentCondition.h"
#import "ForecastCondition.h"
#import "WeatherForecast.h"

@implementation GoogleWeatherTransport

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return self;
}

- (void) dealloc
{
    [dateFormatter release];
    [super dealloc];
}

- (NSString *)createRequestURL:(WeatherRequest*)request
{
    NSMutableString *sURL = [[NSMutableString alloc] initWithString:@"http://www.google.com/ig/api?weather="];
    if ([request zipCode] != NULL)
        [sURL appendString:[request zipCode]];
    if ([request city] != NULL)
        [sURL appendString:[request city]];
    return sURL;
}

- (WeatherForecast *) parseWeatherXML:(NSXMLParser*)parser
{
    forecast = [[WeatherForecast alloc] init];
    futureConditions = [[NSMutableArray alloc] init];
    currentDate = nil;
    
    [parser setDelegate:self];
    [parser parse];
    
    [forecast setFutureConditions:futureConditions];
    [futureConditions release];
    
    return forecast;
}

- (NSDate*) getForecastDate:(NSString*)sDayOfWeek
{
    NSDate* dateBase = [currentCondition date];
    // parse day of week from string
    NSInteger iWeekday = 1;
    NSString *sDay = [sDayOfWeek lowercaseString];
    if ([sDay compare:@"sun"] == NSOrderedSame)
        iWeekday = 1;
    else if ([sDay compare:@"mon"] == NSOrderedSame)
        iWeekday = 2;
    else if ([sDay compare:@"tue"] == NSOrderedSame)
        iWeekday = 3;
    else if ([sDay compare:@"wed"] == NSOrderedSame)
        iWeekday = 4;
    else if ([sDay compare:@"thu"] == NSOrderedSame)
        iWeekday = 5;
    else if ([sDay compare:@"fri"] == NSOrderedSame)
        iWeekday = 6;
    else if ([sDay compare:@"sat"] == NSOrderedSame)
        iWeekday = 7;
    
    // get components of the base date
    NSDateComponents *baseComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:dateBase];
    NSInteger iBaseWeekday = [baseComponents weekday];
    
    // caculate number of days to add to get the forecast date
    NSInteger iDaysDiff = iWeekday - iBaseWeekday;
    if (iDaysDiff < 0)
        iDaysDiff += 7;
    
    // create new date offsetting the base date by specified number of days
    NSDateComponents *resComponents = [[NSDateComponents alloc] init];
    [resComponents setDay:iDaysDiff];
    NSDate* dateResult = [[NSCalendar currentCalendar] dateByAddingComponents:resComponents toDate:dateBase options:0];
    [resComponents release];
    return dateResult;
}

- (NSUInteger) parseHumidity:(NSString*)text
{
    NSString *sPrefix = @"Humidity: ";
    if ([text hasPrefix:sPrefix] == NO)
        return 0;
    NSString *sValue = [text substringFromIndex:[sPrefix length]];
    return [sValue integerValue];
}

- (void) parseWindCondition:(NSString*)windData
{
    // the text must start with Wind: text
    NSString *sPrefix = @"Wind: ";
    if ([windData hasPrefix:sPrefix] == NO)
        return;
    // direction follows the prefix and lasts till witespace (one or to symbols)
    NSString *sData = [windData substringFromIndex:[sPrefix length]];
    NSRange range = [sData rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (range.location == NSNotFound)
        return;
    [activeCondition setWindDirection:[sData substringToIndex:range.location]];
    // speed if the value number in the string
    range = [sData rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (range.location == NSNotFound)
        return;
    NSString *sSpeedText = [sData substringFromIndex:range.location];
    [activeCondition setWindSpeed:[sSpeedText intValue]];
}

- (enum ConditionCode) getConditionCode:(NSString*)cond
{
    NSString *text = [cond uppercaseString];
    if ([text compare:@"PARTLY SUNNY"] == NSOrderedSame)
        return WeatherPartlySunny;
    if ([text compare:@"SCATTERED THUNDERSTORMS"] == NSOrderedSame)
        return WeatherScatteredThunderstorms;
    if ([text compare:@"SHOWERS"] == NSOrderedSame)
        return WeatherShowers;
    if ([text compare:@"SCATTERED SHOWERS"] == NSOrderedSame)
        return WeatherScatteredShowers;
    if ([text compare:@"RAIN AND SNOW"] == NSOrderedSame)
        return WeatherRainAndSnow;
    if ([text compare:@"OVERCAST"] == NSOrderedSame)
        return WeatherOvercast;
    if ([text compare:@"LIGHT SNOW"] == NSOrderedSame)
        return WeatherLightSnow;
    if ([text compare:@"FREEZING DRIZZLE"] == NSOrderedSame)
        return WeatherFreezingDrizzle;
    if ([text compare:@"CHANCE OF RAIN"] == NSOrderedSame)
        return WeatherChanceOfRain;
    if ([text compare:@"SUNNY"] == NSOrderedSame)
        return WeatherSunny;
    if ([text compare:@"CLEAR"] == NSOrderedSame)
        return WeatherClear;
    if ([text compare:@"MOSTLY SUNNY"] == NSOrderedSame)
        return WeatherMostlySunny;
    if ([text compare:@"PARTLY CLOUDY"] == NSOrderedSame)
        return WeatherPartlyCloudy;
    if ([text compare:@"MOSTLY CLOUDY"] == NSOrderedSame)
        return WeatherMostlyCloudy;
    if ([text compare:@"CHANCE OF STORM"] == NSOrderedSame)
        return WeatherChanceOfStorm;
    if ([text compare:@"RAIN"] == NSOrderedSame)
        return WeatherRain;
    if ([text compare:@"CHANCE OF SNOW"] == NSOrderedSame)
        return WeatherChanceOfSnow;
    if ([text compare:@"CLOUDY"] == NSOrderedSame)
        return WeatherCloudy;
    if ([text compare:@"MIST"] == NSOrderedSame)
        return WeatherMist;
    if ([text compare:@"STORM"] == NSOrderedSame)
        return WeatherStorm;
    if ([text compare:@"THUNDERSTORM"] == NSOrderedSame)
        return WeatherThunderstorm;
    if ([text compare:@"CHANCE OF TSTORM"] == NSOrderedSame)
        return WeatherChanceOfStorm;
    if ([text compare:@"SLEET"] == NSOrderedSame)
        return WeatherSleet;
    if ([text compare:@"SNOW"] == NSOrderedSame)
        return WeatherSnow;
    if ([text compare:@"ICY"] == NSOrderedSame)
        return WeatherIcy;
    if ([text compare:@"DUST"] == NSOrderedSame)
        return WeatherDust;
    if ([text compare:@"FOG"] == NSOrderedSame)
        return WeatherFog;
    if ([text compare:@"SMOKE"] == NSOrderedSame)
        return WeatherSmoke;
    if ([text compare:@"HAZE"] == NSOrderedSame)
        return WeatherHaze;
    if ([text compare:@"FLURRIES"] == NSOrderedSame)
        return WeatherFlurries;
    if ([text compare:@"LIGHT RAIN"] == NSOrderedSame)
        return WeatherLightRain;
    if ([text compare:@"SNOW SHOWERS"] == NSOrderedSame)
        return WeatherSnowShowers;
    if ([text compare:@"ICE/SNOW"] == NSOrderedSame)
        return WeatherIceSnow;
    if ([text compare:@"WINDY"] == NSOrderedSame)
        return WeatherWindy;
    if ([text compare:@"SCATTERED SNOW SHOWERS"] == NSOrderedSame)
        return WeatherScatteredSnowShowers;
    return WeatherSunny;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName compare:@"city"] == NSOrderedSame)
    {
        NSString *cityName = [attributeDict objectForKey:@"data"];
        if (cityName != nil)
            [forecast setLocation:cityName];
    }
    else if ([elementName compare:@"forecast_date"] == NSOrderedSame)
    {
        NSString *dateText = [attributeDict objectForKey:@"data"];
        if (dateText != nil)
            [forecast setObservationDate:[dateFormatter dateFromString:dateText]];
    }
    else if ([elementName compare:@"current_conditions"] == NSOrderedSame)
    {
        currentCondition = [[CurrentCondition alloc] init];
        if (currentDate != nil)
            [currentCondition setDate:currentDate];
        activeCondition = currentCondition;
        [forecast setCurrentCondition:currentCondition];
    }
    else if ([elementName compare:@"forecast_conditions"] == NSOrderedSame)
    {
        forecastCondition = [[ForecastCondition alloc] init];
        activeCondition = forecastCondition;
        [futureConditions addObject:forecastCondition];
    }
    else if ([elementName compare:@"temp_f"] == NSOrderedSame && currentCondition != nil)
    {
        NSString *tempData = [attributeDict objectForKey:@"data"];
        if (tempData != nil)
            [currentCondition setTemperature:[tempData integerValue]];
    }
    else if ([elementName compare:@"low"] == NSOrderedSame && forecastCondition != nil)
    {
        NSString *lowData = [attributeDict objectForKey:@"data"];
        if (lowData != nil)
            [forecastCondition setTemperatureLow:[lowData integerValue]];
    }
    else if ([elementName compare:@"high"] == NSOrderedSame && forecastCondition != nil)
    {
        NSString *highData = [attributeDict objectForKey:@"data"];
        if (highData != nil)
            [forecastCondition setTemperatureHigh:[highData integerValue]];
    }
    else if ([elementName compare:@"current_date_time"] == NSOrderedSame)
    {
        NSString *sTimeText = [attributeDict objectForKey:@"data"];
        if (sTimeText != nil)
            currentDate = [dateTimeFormatter dateFromString:sTimeText];
    }
    else if ([elementName compare:@"day_of_week"] == NSOrderedSame &&
             forecastCondition != nil)
    {
        NSString *sDay = [attributeDict objectForKey:@"data"];
        if (sDay != nil)
            [forecastCondition setDate:[self getForecastDate:sDay]];
    }
    else if ([elementName compare:@"humidity"] == NSOrderedSame && currentCondition != nil)
    {
        NSString *sHumidityText = [attributeDict objectForKey:@"data"];
        if (sHumidityText != nil)
            [currentCondition setHumidity:[self parseHumidity:sHumidityText]];
    }
    else if ([elementName compare:@"wind_condition"] == NSOrderedSame && activeCondition != nil)
    {
        NSString *sWindData = [attributeDict objectForKey:@"data"];
        if (sWindData != nil)
            [self parseWindCondition:sWindData];
    }
    else if ([elementName compare:@"condition"] == NSOrderedSame && activeCondition != nil)
    {
        NSString *sCondition = [attributeDict objectForKey:@"data"];
        if (sCondition != nil)
            [activeCondition setCode:[self getConditionCode:sCondition]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName compare:@"current_conditions"] == NSOrderedSame)
    {
        if (currentCondition != nil)
        {
            [currentCondition release];
            currentCondition = nil;
        }
    }
    else if ([elementName compare:@"forecast_conditions"] == NSOrderedSame)
    {
        if (forecastCondition != nil)
        {
            [forecastCondition release];
            forecastCondition = nil;
        }
    }
}

@end
