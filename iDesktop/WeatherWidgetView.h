//
//  WeatherWidgetView.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherWidgetView : UIView
{
    NSMutableArray* listPages;
}
@property (assign) UIScrollView *scrollView;
@property (assign) UIPageControl *pageControl;
@property (assign) UIToolbar *toolbar;
@property (readonly) NSArray *pages;

- (void) addPage:(UIView *)page;
- (void) removePage:(UIView *)page;

@end
