//
//  NewsWidgetView.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsWidgetView.h"
#import "ScrollableTabControl.h"

@implementation NewsWidgetView

@synthesize tabControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    if (tabControl != nil)
    {
        CGSize size = [tabControl sizeThatFits:tabControl.frame.size];
        size.height += 40;
        size.width += 60;
        tabControl.frame = CGRectMake(0, 0, self.frame.size.width, size.height);
    }
}

@end
