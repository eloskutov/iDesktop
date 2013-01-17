//
//  NewLocationViewController.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherTransportDelegate.h"

@protocol WeatherNewLocationDelegate;
@protocol WeatherTransportDelegate;

@interface NewWeatherLocationViewController : UIViewController<WeatherTransportDelegate>
{
    UISearchBar *searchBar;
    UIButton *searchButton;
    UIActivityIndicatorView *loadingIndicator;
}

@property (assign) id<WeatherNewLocationDelegate> delegate;

@end
