//
//  WeatherForecastView.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherForecast;

@interface WeatherForecastView : UIView
{
    CGFloat paddingLeft;
    CGFloat paddingTop;
    CGFloat paddingRight;
    CGFloat paddingBottom;
    CGFloat forecastPaddingTop;
    CGFloat forecastVertGap;
    
    WeatherForecast *_forecast;
    
    UIImageView *todayImage;
    UILabel *temperatureLabel;
    UILabel *humidityLabel;
    UILabel *cityLabel;
    NSMutableArray *listForecast;
}

@property (retain) WeatherForecast* forecast;

@end
