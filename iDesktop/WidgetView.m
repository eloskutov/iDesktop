//
//  WidgetView.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WidgetView.h"
#import "GridLayout.h"
#import "GridCellLayout.h"
#import "GridColumnLayout.h"
#import "DesktopView.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat g_dTitlePadding = 5;
static const CGFloat g_dTitleHeight = 23;
static const CGFloat g_dTitleTextPaddingLeft = 10;
static const CGFloat g_dTitleTextPaddingTop = 22;

static const CGFloat g_dBkColor = 153.0 / 255.0;
static const CGFloat g_dTitleColor = 76.0 / 255.0;
static const CGFloat g_dTitlePressedColor = 51.0 / 255.0;
static const char* g_szFontName = "Helvetica";
static const CGFloat g_dFontSize = 16;


@implementation WidgetView

@synthesize viewId;
@synthesize cell;
@dynamic isDragging;
@dynamic isExpanded;
@dynamic contentView;

- (id) initWithId:(NSString*)sViewId frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isPressed = false;
        self.viewId = sViewId;
        
        [[self layer] setCornerRadius:4.0];
        [[self layer] setMasksToBounds:YES];
        
        [self setContentMode:UIViewContentModeRedraw];
        [self setAutoresizingMask:UIViewAutoresizingNone];
        self.autoresizesSubviews = NO;
    }
    return self;    
}

- (UIView *)contentView
{
    return _contentView;
}

- (void)setContentView:(UIView *)contentView
{
    if (_contentView != nil)
    {
        [_contentView removeFromSuperview];
        [_contentView release];
    }
    _contentView = contentView;
    if (_contentView != nil)
    {
        [self addSubview:_contentView];
        [_contentView retain];
        [self setNeedsLayout];
    }
}

- (bool) isDragging
{
    return _isDragging;
}

- (void) setIsDragging:(bool)bIsDragging
{
    _isDragging = bIsDragging;
    [self setAlpha:(_isDragging ? 0.7 : 1.0)];
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!isPressed) {
        isTouchMoved = false;
        isPressed = true;
        UITouch *touch = [touches anyObject];
        pointDragStart = [touch locationInView:[self superview]];
        pointCenter = [self center];
        originalFrame = [self frame];
        [self setNeedsDisplay];
    }
}

- (void)animateLayout
{
    [[self superview] setNeedsLayout];
    [UIView animateWithDuration:0.2 animations:^{
        [[self superview] layoutIfNeeded]; 
    }];    
}

- (void) processTouch:(CGPoint)pt
{
    if (pt.y < g_dTitleHeight + g_dTitlePadding) {
        [self setIsExpanded:![self isExpanded]];
        [self animateLayout];
    }    
}

- (void) stopDragging
{
    if (isPressed) {
        isPressed = false;
        [self setIsDragging:false];
        [self setNeedsDisplay];
        [self animateLayout];
    }    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self stopDragging];
    if (!isTouchMoved && [touches count] > 0) {
        UITouch *touch = [touches anyObject];
        [self processTouch:[touch locationInView:self]];
        isTouchMoved = true;
    }
}

- (void)moveToCell:(WidgetView*)widget
{
    // Decide where to insert self: below the widget or above
    CGPoint sourceCenter = [self center];
    CGPoint targetCenter = [widget center];
    GridCellLayout *widgetCell = [widget cell];
    GridColumnLayout *targetColumn = [widgetCell column];
    NSUInteger index = [[targetColumn cellList] indexOfObject:widgetCell];
    if (sourceCenter.y > targetCenter.y)
        index++;
    
    // If column is different then remove cell from its original column first
    GridColumnLayout *sourceColumn = [[self cell] column];
    if (sourceColumn != targetColumn)
        [sourceColumn removeCell:[self cell]];
    
    // Add widget to the new column at the calculated index
    [targetColumn addCell:[self cell] atIndex:index];
    
    // Animate new layout
    [self animateLayout];
}

- (void)checkCellMoved
{
    // try to find the widget where the center point is located
    DesktopView *owner = (DesktopView*)[self superview];
    GridLayout *layout = [owner layout];
    NSMutableArray *widgets = [owner widgetList];
    CGPoint sourceCenter = [self center];
    for (WidgetView *childWidget in widgets)
    {
        if (childWidget == self)
            continue;
        
        CGRect rectFrame = [childWidget frame];
        CGRectInset(rectFrame, -[layout horizontalGap], -[layout verticalGap]);
        
        if (CGRectContainsPoint(rectFrame, sourceCenter))
        {
            // if center point is above a different widget, then move widget to new position
            [self moveToCell:childWidget];
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (isPressed && !_isDragging)
    {
        isTouchMoved = true;
        [self setIsDragging:true];
    }
    
    // Drag the widget
    UITouch *touch = [touches anyObject];
    CGPoint pointNew = [touch locationInView:[self superview]];
    CGPoint pointCenterNew = pointCenter;
    pointCenterNew.x += pointNew.x - pointDragStart.x;
    pointCenterNew.y += pointNew.y - pointDragStart.y;
    [self setCenter:pointCenterNew];
    [self checkCellMoved];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopDragging];
}

- (void)dealloc
{
    [self setContentView:nil];
    [self setCell:NULL];
    [self setViewId:NULL];
    [backgroundImage release];
    [super dealloc];
}

- (bool) isExpanded
{
    return [self cell] != NULL ? ![[self cell] isFixedHeight] : true;
}

- (void) setIsExpanded:(bool)isExpanded
{
    if ([self cell] != NULL) {
        _contentView.hidden = !isExpanded;
        [[self cell] setFixedHeight:(g_dTitleHeight + 2 * g_dTitlePadding)];
        [[self cell] setIsFixedHeight:!isExpanded];
        
        [[self superview] setNeedsLayout];
    }
}   

- (CGRect) makeContentRect
{
    CGRect rc = [self bounds];
    return CGRectMake(g_dTitlePadding, g_dTitlePadding * 2 + g_dTitleHeight, 
                      rc.size.width - 2 * g_dTitlePadding, 
                      rc.size.height - g_dTitlePadding * 3 - g_dTitleHeight);
}

- (void) layoutSubviews
{
    if (_contentView != nil)
        [_contentView setFrame:[self makeContentRect]];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rc = [self bounds];
//    CGRect rc2 = [self frame];
    //[backgroundImage drawInRect:rc];
    
    // Paint main rectangle of the widget
    CGContextSetRGBFillColor(context, g_dBkColor, g_dBkColor, g_dBkColor, 1);
    CGContextFillRect(context, rc);
    
    // Paint title rectangle of the widget
    CGFloat dTitleColor = isPressed ? g_dTitlePressedColor : g_dTitleColor;
    CGContextSetRGBFillColor(context, dTitleColor, dTitleColor, dTitleColor, 1);
    /*CGContextFillRect(context, CGRectMake(g_dTitlePadding, g_dTitlePadding, 
                                          rc.size.width - 2 * g_dTitlePadding, 
                                          g_dTitleHeight));
    */
    CGRect rcContent = [self makeContentRect];
    
    if ([self isExpanded]) 
    {
        // Paint background for the inner view
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextFillRect(context, rcContent);
        
        [self setContentStretch:CGRectMake(rcContent.origin.x / rc.size.width, rcContent.origin.y / rc.size.height,
                                           rcContent.size.width / rc.size.width, rcContent.size.height / rc.size.height)];
    }
    else
    {
        [self setContentStretch:CGRectMake(rcContent.origin.x / rc.size.width, rcContent.origin.y / rc.size.height,
                                           rcContent.size.width / rc.size.width, rcContent.size.height / rc.size.height)];        
    }
    
    // Paint widget title
   	CGContextSelectFont(context, g_szFontName, g_dFontSize, kCGEncodingMacRoman);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1); 
	// Next we set the text matrix to flip our text upside down. We do this because the context itself
	// is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    
    CGContextShowTextAtPoint(context, g_dTitleTextPaddingLeft, g_dTitleTextPaddingTop, 
                             [viewId cStringUsingEncoding:NSASCIIStringEncoding],
                             [viewId length]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
