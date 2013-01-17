//
//  ScrollableTabControl.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrollableTabControl.h"
#import "TabControlItem.h"

@implementation ScrollableTabControl

@synthesize edgeInsets;
@dynamic items;
@dynamic selectedItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tabItems = nil;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        
        edgeInsets = UIEdgeInsetsMake(2, 2, 3, 4);
        
        self.autoresizesSubviews = NO;
    }
    return self;
}

- (NSArray*)items
{
    return tabItems;
}

- (void)setItems:(NSArray*)aItems
{
    TabControlItem *item;
    if (tabItems != nil)
    {
        for (item in tabItems) {
            item.tabControl = nil;
            [item removeFromSuperview];
        }
    }
    tabItems = [aItems copy];
    if (tabItems != nil)
    {
        for (item in tabItems) {
            item.tabControl = self;
            [item sizeToFit];
            [scrollView addSubview:item];
        }        
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    CGFloat x = edgeInsets.left;
    for (TabControlItem *item in tabItems)
    {
        item.frame = CGRectMake(x, edgeInsets.top, 
                                item.frame.size.width, 
                                item.frame.size.height);
        x += item.frame.size.width;
    }
    scrollView.frame = CGRectMake(edgeInsets.left, edgeInsets.top, 
                                  self.frame.size.width - edgeInsets.left - edgeInsets.right, 
                                  self.frame.size.height - edgeInsets.top - edgeInsets.bottom);
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeTotal = CGSizeMake(0, 0);
    for (TabControlItem *item in tabItems)
    {
        CGSize sizeItem = [item sizeThatFits:size];
        sizeTotal.width += sizeItem.width;
        sizeTotal.height = MAX(sizeTotal.height, sizeItem.height);
    }
    sizeTotal.width += (edgeInsets.left + edgeInsets.right);
    sizeTotal.height += (edgeInsets.top + edgeInsets.bottom);
    return sizeTotal;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rc = [self bounds];
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1);
    CGContextFillRect(context, rc);    
}

- (TabControlItem*)selectedItem
{
    return selectedItem;
}

- (void)setSelectedItem:(TabControlItem *)item
{
    if (selectedItem != nil)
        selectedItem.selected = NO;
    selectedItem = item;
    if (selectedItem != nil)
        selectedItem.selected = YES;
}

@end
