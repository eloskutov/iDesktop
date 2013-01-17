//
//  WeatherWidgetView.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherWidgetView.h"

static const CGFloat g_dPagerColor = 76.0 / 255.0;

@implementation WeatherWidgetView

@synthesize scrollView;
@synthesize pageControl;
@synthesize toolbar;
@dynamic pages;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        listPages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [listPages release];
    [super dealloc];
}

- (NSArray*)pages
{
    return listPages;
}

- (void) addPage:(UIView *)page
{
    [listPages addObject:page];
    [scrollView addSubview:page];
    [self setNeedsLayout];
    pageControl.numberOfPages = listPages.count;
    pageControl.currentPage = listPages.count - 1;
    
    [self layoutIfNeeded];
    [scrollView scrollRectToVisible:page.frame animated:YES];
}

- (void) removePage:(UIView *)page
{
    if ([listPages indexOfObject:page] != NSNotFound)
    {
        [listPages removeObject:page];
        [page removeFromSuperview];
        pageControl.numberOfPages = listPages.count;
        [self setNeedsLayout];
    }
}

- (void) layoutSubviews
{
    if (pageControl == nil || scrollView == nil)
        return;
    
    CGSize sizePager = CGSizeMake(0, 30);
    toolbar.frame = CGRectMake(0, self.frame.size.height - sizePager.height, self.frame.size.width, 
                               sizePager.height);
    pageControl.frame = CGRectMake(40, 0, self.frame.size.width - 80, sizePager.height);
    CGRect pageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - sizePager.height);
    scrollView.frame = pageFrame;
    scrollView.contentSize = CGSizeMake(pageFrame.size.width * listPages.count, 
                                            pageFrame.size.height);
    CGFloat x = 0;
    for (UIView *page in listPages) 
    {
         page.frame = CGRectMake(x, 0, pageFrame.size.width, pageFrame.size.height);
         x += pageFrame.size.width;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (pageControl == nil)
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rc = [self bounds];
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rc);    
}


@end
