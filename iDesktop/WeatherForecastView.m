//
//  WeatherForecastView.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherForecastView.h"
#import "WeatherForecast.h"
#import "ForecastItemView.h"
#import "WeatherCondition.h"
#import "CurrentCondition.h"
#import "ForecastCondition.h"

@implementation WeatherForecastView

@dynamic forecast;

- (ForecastItemView*)createForecastItem
{
    ForecastItemView* item = [[ForecastItemView alloc] init];
    
    item.conditionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [self addSubview:item.conditionImage];
    
    item.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    item.dayLabel.font = [UIFont systemFontOfSize:32];
    [self addSubview:item.dayLabel];
    
    item.highTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    item.highTempLabel.font = [UIFont systemFontOfSize:32];
    [self addSubview:item.highTempLabel];
    
    item.lowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    item.lowTempLabel.font = [UIFont systemFontOfSize:32];
    item.lowTempLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [self addSubview:item.lowTempLabel];
        
    return [item autorelease];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        paddingLeft = 10;
        paddingTop = 10;
        paddingRight = 10;
        paddingBottom = 10;
        forecastPaddingTop = 10;
        forecastVertGap = 10;
        
        // Init child views
        todayImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        [self addSubview:todayImage];
        
        temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        temperatureLabel.font = [UIFont boldSystemFontOfSize:80];
        [self addSubview:temperatureLabel];
        
        humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:humidityLabel];
    
        cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        cityLabel.font = [UIFont boldSystemFontOfSize:26];
        [self addSubview:cityLabel];
        
        listForecast = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i++)
            [listForecast addObject:[self createForecastItem]];
    }
    return self;
}

- (WeatherForecast*)forecast
{
    return _forecast;
}

- (UIImage *)imageWithCondition:(enum ConditionCode)code
{
    NSString *sImageName = @"sun-clear.png";
    switch (code) {
        case WeatherPartlySunny:
            sImageName = @"sun-and-clouds.png";
            break;
        case WeatherScatteredThunderstorms:
            sImageName = @"thunderstorm-sunny.png";
            break;
        case WeatherShowers:
            sImageName = @"rain-heavy.png";
            break;
        case WeatherScatteredShowers:
            sImageName = @"sun-and-rain.png";
            break;
        case WeatherRainAndSnow:
            sImageName = @"rain-snow.png";
            break;
        case WeatherOvercast:
            sImageName = @"cloudy.png";
            break;
        case WeatherLightSnow:
            sImageName = @"snow-light.png";
            break;
        case WeatherFreezingDrizzle:
            sImageName = @"grad.png";
            break;
        case WeatherChanceOfRain:
            sImageName = @"rain-light.png";
            break;
        case WeatherSunny:
            sImageName = @"sun-clear.png";
            break;
        case WeatherClear:
            sImageName = @"sun-clear.png";
            break;
        case WeatherMostlySunny:
            sImageName = @"sun-cloudy-light.png";
            break;
        case WeatherPartlyCloudy:
            sImageName = @"sun-clouds.png";
            break;
        case WeatherMostlyCloudy:
            sImageName = @"cloudy.png";
            break;
        case WeatherChanceOfStorm:
            sImageName = @"rain-heavy-windy.png";
            break;
        case WeatherRain:
            sImageName = @"rain-medium.png";
            break;
        case WeatherChanceOfSnow:
            sImageName = @"sun-and-snow.png";
            break;
        case WeatherCloudy:
            sImageName = @"cloudy.png";
            break;
        case WeatherMist:
            sImageName = @"cloudy.png";
            break;
        case WeatherStorm:
            sImageName = @"rain-heavy-windy.png";
            break;
        case WeatherThunderstorm:
            sImageName = @"heavy-thunderstorm.png";
            break;
        case WeatherChangeOfTStorm:
            sImageName = @"thunderstorm-sunny.png";
            break;
        case WeatherSleet:
            sImageName = @"rain-snow.png";
            break;
        case WeatherSnow:
            sImageName = @"snow-medium.png";
            break;
        case WeatherIcy:
            sImageName = @"grad.png";
            break;
        case WeatherDust:
            sImageName = @"sun-hazy.png";
            break;
        case WeatherFog:
            sImageName = @"sun-hazy.png";
            break;
        case WeatherSmoke:
            sImageName = @"sun-hazy.png";
            break;
        case WeatherHaze:
            sImageName = @"sun-hazy.png";
            break;
        case WeatherFlurries:
            sImageName = @"snow-light.png";
            break;
        case WeatherLightRain:
            sImageName = @"rain-light.png";
            break;
        case WeatherSnowShowers:
            sImageName = @"snow-heavy.png";
            break;
        case WeatherIceSnow:
            sImageName = @"snow-medium.png";
            break;
        case WeatherWindy:
            sImageName = @"sun-clear.png";
            break;
        case WeatherScatteredSnowShowers:
            sImageName = @"sun-and-snow.png";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:sImageName];
}

- (NSString*)formatTemperature:(NSInteger)temperature
{
    return [NSString stringWithFormat:@"%d\u00b0", temperature];
}

- (NSString*)getDayOfWeekName:(NSInteger)day
{
    switch (day) {
        case 1:
            return @"Sunday";
        case 2:
            return @"Monday";
        case 3:
            return @"Tuesday";
        case 4:
            return @"Wednesday";
        case 5:
            return @"Thursday";
        case 6:
            return @"Friday";
        case 7:
            return @"Saturday";
    }
    return @"";
}

- (void)setForecast:(WeatherForecast *)forecast
{
    if (_forecast != nil)
        [_forecast release];
    _forecast = forecast;
    if (_forecast != nil)
    {
        [_forecast retain];
        
        // Assign data
        CurrentCondition *currentCondition = [_forecast currentCondition];
        todayImage.image = [self imageWithCondition:[currentCondition code]];
        
        NSInteger temp = [currentCondition temperature];
        temperatureLabel.text = [self formatTemperature:temp];
        [temperatureLabel sizeToFit];
        
        NSUInteger humidity = [currentCondition humidity];
        humidityLabel.text = [NSString stringWithFormat:@"Humidity: %d%%", humidity];
        [humidityLabel sizeToFit];
        
        cityLabel.text = [_forecast location];
        [cityLabel sizeToFit];
        
        for (int i = 0; i < _forecast.futureConditions.count; i++) {
            if (i >= [listForecast count])
                break;
            ForecastCondition *futureCondition = [_forecast.futureConditions objectAtIndex:i];
            ForecastItemView *item = [listForecast objectAtIndex:i];
            item.highTempLabel.text = [self formatTemperature:futureCondition.temperatureHigh];
            [item.highTempLabel sizeToFit];
            item.lowTempLabel.text = [self formatTemperature:futureCondition.temperatureLow];
            [item.lowTempLabel sizeToFit];
            item.conditionImage.image = [self imageWithCondition:futureCondition.code];
            
            NSDateComponents *baseComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:futureCondition.date];
            item.dayLabel.text = [self getDayOfWeekName:baseComponents.weekday];
            [item.dayLabel sizeToFit];
        }
        
        [self setNeedsLayout];
    }
}

- (void) layoutSubviews
{
    // image at the top left
    CGRect rc = todayImage.frame;
    rc.origin = CGPointMake(paddingLeft, paddingTop);
    todayImage.frame = rc;
    
    // temperature and humidity at the right
    CGFloat widthMax = MAX(temperatureLabel.frame.size.width, humidityLabel.frame.size.width);
    CGFloat heightSum = temperatureLabel.frame.size.height + humidityLabel.frame.size.height;
    CGFloat xLabel = self.frame.size.width - paddingRight - widthMax;
    CGFloat yLabel = paddingTop + (todayImage.frame.size.width - heightSum) / 2;
    
    rc = temperatureLabel.frame;
    rc.origin = CGPointMake(xLabel, yLabel);
    temperatureLabel.frame = rc;
    
    rc = humidityLabel.frame;
    rc.origin = CGPointMake(xLabel, yLabel + temperatureLabel.frame.size.height);
    humidityLabel.frame = rc;
    
    rc = cityLabel.frame;
    rc.origin = CGPointMake(self.frame.size.width - paddingRight - cityLabel.frame.size.width, 0);
    cityLabel.frame = rc;
    
    // align forecast at the bottom
    CGFloat y = todayImage.frame.origin.y + todayImage.frame.size.height + forecastPaddingTop;
    for (ForecastItemView *item in listForecast)
    {
        // place day at the left
        rc = item.dayLabel.frame;
        rc.origin = CGPointMake(paddingLeft, y);
        item.dayLabel.frame = rc;
        
        // place low and high at the right
        rc = item.lowTempLabel.frame;
        rc.origin = CGPointMake(self.frame.size.width - paddingRight - rc.size.width, y);
        item.lowTempLabel.frame = rc;
        
        rc = item.highTempLabel.frame;
        rc.origin = CGPointMake(item.lowTempLabel.frame.origin.x - rc.size.width, y);
        item.highTempLabel.frame = rc;
        
        item.conditionImage.center = CGPointMake(rc.origin.x - 40, 
                                                 y + item.conditionImage.frame.size.height / 2.0 - 5);
        
        y += rc.size.height + forecastVertGap;
    }
}

- (void)dealloc
{
    self.forecast = nil;
    [todayImage release];
    [temperatureLabel release];
    [humidityLabel release];
    
    for (ForecastItemView *item in listForecast) {
        [item.lowTempLabel release];
        [item.highTempLabel release];
        [item.conditionImage release];
        [item.dayLabel release];
    }
    [listForecast release];
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
