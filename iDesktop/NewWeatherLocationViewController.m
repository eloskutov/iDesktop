//
//  NewLocationViewController.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewWeatherLocationViewController.h"
#import "NewWeatherLocationView.h"
#import "WeatherForecast.h"
#import "WeatherTransport.h"
#import "GoogleWeatherTransport.h"
#import "WeatherRequest.h"
#import "WeatherTransportDelegate.h"
#import "WeatherNewLocationDelegate.h"

@implementation NewWeatherLocationViewController

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) dealloc
{
    [searchBar release];
    
    [super dealloc];
}

- (void) loadView
{
    CGRect frameRect = CGRectMake(0, 0, 200, 200);
    NewWeatherLocationView *locationView = [[NewWeatherLocationView alloc] initWithFrame:frameRect];
    locationView.autoresizesSubviews = YES;
    /*
    UINavigationBar navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    UIBarButtonItem *mySpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(refresh)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
    
    UIToolbar *topToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,100,40)];
    
    [topToolbar setItems:[NSArray arrayWithObjects:mySpacer, searchButton, nil] animated:NO];
    topToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    */
    // Initialization code
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 1, frameRect.size.width, 
                                                              40)];
    //bar.prompt = @"Location:";
    bar.placeholder = @"City name or zip code";
    bar.showsCancelButton = false;
    bar.showsBookmarkButton = false;
    bar.showsScopeBar = false;
    
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    searchBar = bar;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 45, frameRect.size.width, 40);
    [button addTarget:self action:@selector(onAddLocation:) 
        forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Search" forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    searchButton = button;
    
    //[locationView addSubview:topToolbar];    
    [locationView addSubview:bar];
    [locationView addSubview:button];
    
    [bar release];
    /*[mySpacer release];
    [searchButton release];
    [topToolbar release];*/
    
    self.view = locationView;
    [locationView release];
}

- (void) onAddLocation:(id)sender
{
    // hide keyboard
    [searchBar resignFirstResponder];
    
    // display activity indicator in the middle of the view
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator startAnimating];
    [self.view addSubview:loadingIndicator];
    [loadingIndicator setCenter:CGPointMake(self.view.frame.size.width / 2, 
                                            self.view.frame.size.height / 2)];
    
    // disable view
    searchBar.alpha = 0.5;
    searchButton.enabled = NO;
    
    // create and send weather request
    WeatherRequest *request = [[WeatherRequest alloc] init];
    request.city = [searchBar text];
    
    GoogleWeatherTransport *transport = [[GoogleWeatherTransport alloc] init];
    [transport loadForecast:request delegate:self];
}

- (void) stopProgress
{
    searchBar.alpha = 1;
    searchButton.enabled = YES;
    [loadingIndicator removeFromSuperview];
    [loadingIndicator release];
}

- (void) transport:(id<WeatherTransport>)transport didLoadForecast:(WeatherForecast*)forecast
{
    if (self.delegate != nil)
        [self.delegate addLocationWithForecast:forecast];
    [transport release];
    [self stopProgress];
}

- (void) transport:(id<WeatherTransport>)transport didFailWithError:(NSError*)error
{
    [transport release];
    [self stopProgress];
}

@end
