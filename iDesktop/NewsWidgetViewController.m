//
//  NewsWidgetViewController.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsWidgetViewController.h"
#import "NewsWidgetView.h"
#import "ScrollableTabControl.h"
#import "TabControlItem.h"

@implementation NewsWidgetViewController


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
    widget = [[NewsWidgetView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    ScrollableTabControl *tabControl = [[ScrollableTabControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [widget addSubview:tabControl];
    widget.tabControl = tabControl;
    [tabControl release];
    
    TabControlItem *item1 = [[TabControlItem alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    item1.text = @"Engadget";
    TabControlItem *item2 = [[TabControlItem alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    item2.text = @"USA Today";
    TabControlItem *item3 = [[TabControlItem alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    item3.text = @"The New York Times";
    TabControlItem *item4 = [[TabControlItem alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    item4.text = @"The Wall Street Journal";
    
    NSArray *items = [[NSArray alloc] initWithObjects:item1, item2, item3, item4, nil];
    widget.tabControl.items = items;
    [widget.tabControl sizeToFit];
    widget.tabControl.selectedItem = item1;
    [items release];
    
    [widget setNeedsLayout];
    
    self.view = widget;
    
    [widget release];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
