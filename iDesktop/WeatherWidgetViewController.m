//
//  WeatherWidgetViewController.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherWidgetViewController.h"
#import "WeatherWidgetView.h"
#import "NewWeatherLocationViewController.h"
#import "WeatherNewLocationDelegate.h"
#import "WeatherForecastView.h"

@implementation WeatherWidgetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // create top widget view
    CGRect frameRect = CGRectMake(0, 0, 100, 100);
    WeatherWidgetView *widget = [[WeatherWidgetView alloc] initWithFrame:frameRect];
    widget.autoresizesSubviews = NO;
    
    // create scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frameRect];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    [widget addSubview:scrollView];
    widget.scrollView = scrollView;
    [scrollView release];
    
    // create pager
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frameRect];
    pageControl.hidesForSinglePage = NO;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    widget.pageControl = pageControl;
    
    // create toolbar
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIBarButtonItem *itemPager = [[UIBarButtonItem alloc] initWithCustomView:pageControl];
    trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onTrash:)];
    trashButton.enabled = NO;
    UIBarButtonItem *itemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd:)];
    itemAdd.enabled = YES;
    NSArray *items = [[NSArray alloc] initWithObjects:trashButton, itemPager, itemAdd, nil];
    [toolbar setItems:items];
    [items release];
    [itemPager release];
    [itemAdd release];
    [widget addSubview:toolbar];
    widget.toolbar = toolbar;
    
    [pageControl release];
    
    // create new page controller
    newPageController = [[NewWeatherLocationViewController alloc] init];    
    newPageController.delegate = self;
    newPageController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [widget addPage:newPageController.view];
        
    // setup view
    self.view = widget;
    widgetView = widget;
    
    [widget release];
}

- (void) onTrash:(id)sender
{
    int index = widgetView.pageControl.currentPage;
    UIView *page = [widgetView.pages objectAtIndex:index];
    [widgetView removePage:page];
}

- (void) onAdd:(id)sender
{
    [widgetView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    widgetView.pageControl.currentPage = 0;
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [widgetView.pageControl removeTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [newPageController release];
    [trashButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (!pageControlUsed)
    {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = widgetView.scrollView.frame.size.width;
        int page = floor((widgetView.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        widgetView.pageControl.currentPage = page;        
    }
	    
    trashButton.enabled = widgetView.pageControl.currentPage == 0 ? NO : YES;    
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)changePage:(id)sender
{
    int page = widgetView.pageControl.currentPage;
	    
	// update the scroll view to the appropriate page
    CGRect frame = widgetView.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [widgetView.scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

- (void) addLocationWithForecast:(WeatherForecast*)forecast
{
    WeatherForecastView *view = [[WeatherForecastView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.forecast = forecast;
    [widgetView addPage:view];
    [view release];
}

@end
