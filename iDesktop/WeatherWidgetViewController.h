//
//  WeatherWidgetViewController.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherNewLocationDelegate.h"

@class WeatherWidgetView;
@class NewWeatherLocationViewController;

@interface WeatherWidgetViewController : UIViewController<UIScrollViewDelegate,WeatherNewLocationDelegate>
{
    UIBarButtonItem *trashButton;
    WeatherWidgetView *widgetView;
    NewWeatherLocationViewController *newPageController;
    BOOL pageControlUsed;
}

@end
