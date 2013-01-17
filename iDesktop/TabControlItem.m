//
//  TabControlItem.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabControlItem.h"
#import "ScrollableTabControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation TabControlItem

@dynamic text;
@synthesize titleEdgeInsets;
@synthesize tabControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat compS[] = {0, 102.0 / 255.0, 228.0 / 255.0, 1};
        selectedColor = CGColorCreate(colorSpace, compS);
        CGFloat compH[] = {0.7, 0.7, 0.7, 1};
        highlightColor = CGColorCreate(colorSpace, compH);
        CGFloat compN[] = {0.5, 0.5, 0.5, 1};
        normalColor = CGColorCreate(colorSpace, compN);
        
        normalTextColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
        selectedTextColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
        highlightedTextColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:1];
        
        //self.opaque = NO;
        //self.layer.cornerRadius = 4.0;
        //self.layer.masksToBounds = YES;
        
        titleEdgeInsets = UIEdgeInsetsMake(5, 10, 9, 10);
        label = [[UILabel alloc] initWithFrame:frame];
        [label sizeToFit];
        [self addSubview:label];
        
        CGColorSpaceRelease(colorSpace);
    }
    
    return self;
}

- (void)dealloc
{
    [normalTextColor release];
    [selectedTextColor release];
    [highlightedTextColor release];
    CGColorRelease(selectedColor);
    CGColorRelease(highlightColor);
    CGColorRelease(normalColor);
    [label release];
    [super dealloc];
}

- (NSString*)text
{
    return [label text];
}

- (void)setText:(NSString *)text
{
    [label setText:text];
    [label sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize sz = [label sizeThatFits:size];
    sz.width += self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    sz.height += self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
    return sz;
}

- (void)layoutSubviews
{
    [label setFrame:CGRectMake(self.titleEdgeInsets.left, self.titleEdgeInsets.top, 
                               label.frame.size.width, label.frame.size.height)];
}

- (void)addRoundRectanglePath:(CGContextRef)context rectangle:(CGRect)rc
{
    CGFloat radius = floor(rc.size.height / 2.0) - 1;
    CGContextBeginPath(context);
    CGContextAddArc(context, radius + 1, radius, radius, M_PI / 2.0, 3.0 * M_PI / 2.0, 0);
    CGContextAddLineToPoint(context, rc.size.width - radius - 1, 0);
    CGContextAddArc(context, rc.size.width - radius - 1, radius, radius, 3.0 * M_PI / 2.0, M_PI / 2.0, 0);
    CGContextAddLineToPoint(context, radius, 2 * radius);
}

- (void)drawRect:(CGRect)rect
{
    // Only do some drawing in selected or highlighted states
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rc = [self bounds];

    // Fill background by the normal color first
    CGContextSetFillColorWithColor(context, normalColor);
    CGContextFillRect(context, rc);

    CGColorRef clr = nil;
    if (self.selected)
        clr = selectedColor;
    else if (self.highlighted)
        clr = highlightColor;
    else
        clr = normalColor;
    [label setBackgroundColor:[UIColor colorWithCGColor:clr]];
    
    if (self.selected || self.highlighted)
    {
        CGContextSetFillColorWithColor(context, clr);
        
        // Now paint rectangle with semispheres on left and right
        [self addRoundRectanglePath:context rectangle:rc];
        CGContextFillPath(context);
    }
    
    if (self.selected)
        [label setTextColor:selectedTextColor];
    else if (self.highlighted)
        [label setTextColor:highlightedTextColor];
    else
        [label setTextColor:normalTextColor];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.highlighted)
        self.tabControl.selectedItem = self;
    [self setNeedsDisplay];    
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.selected)
    {
        [self setNeedsDisplay];
        return YES;
    }
    else
        return NO;
}

@end
