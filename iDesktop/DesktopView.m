//
//  DesktopView.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DesktopView.h"
#import "GridCellLayout.h"
#import "GridColumnLayout.h"
#import "GridLayout.h"
#import "WidgetView.h"
#import "WeatherWidgetViewController.h"
#import "NewsWidgetViewController.h"
#import <math.h>


@interface DesktopView(private)

- (WidgetView *) findByViewId:(NSString*)viewId;

- (void) layoutColumn:(GridColumnLayout*)column x:(CGFloat)x y:(CGFloat)y
            width:(CGFloat)width height:(CGFloat)height;

- (void) addDebugWidget:(NSString*)viewId;

- (GridLayout *) createLandscapeLayout;
- (GridLayout *) createPortraitLayout;

@end

@implementation DesktopView(private)

- (void) layoutColumn:(GridColumnLayout*)column x:(CGFloat)xStart y:(CGFloat)yStart
                width:(CGFloat)columnWidth height:(CGFloat)columnHeight
{
    CGFloat dAvailableHeight = columnHeight;
    CGFloat dTotalPercentHeight = 0;
    GridCellLayout *cell;
    WidgetView *widget;
    
    // Calculate summary height of all cells in percent and subtract
    // fixed height from available height
    int iCellCount = 0;
    for (cell in [column cellList])
    {
        if (![cell isIncludedInLayout])
            continue;
        iCellCount++;
        if (![cell isFixedHeight])
            dTotalPercentHeight += [cell percentHeight];
        else
        {
            widget = [self findByViewId:[cell viewId]];
            if (widget != NULL)
                dAvailableHeight -= [cell fixedHeight];
        }
    }
    if (iCellCount > 0)
        dAvailableHeight -= [[self layout] horizontalGap] * (iCellCount - 1);
    
    // layout widgets
    CGFloat dStartY = yStart;
    CGFloat dHeight = 0;
    for (cell in [column cellList])
    {
        widget = [self findByViewId:[cell viewId]];
        if (widget == NULL)
            continue;
        if ([cell isFixedHeight])
            dHeight = [cell fixedHeight];
        else
            dHeight = round(dAvailableHeight * [cell percentHeight] / dTotalPercentHeight);
        
        if (![widget isDragging])
            [widget setFrame:CGRectMake(xStart, dStartY, columnWidth, dHeight)];
        [widget setCell:cell];
        
        dStartY += dHeight + [[self layout] verticalGap];
    }
}

- (WidgetView *) findByViewId:(NSString*)viewId
{
    for (WidgetView *widget in widgets)
    {
        if ([widget viewId] == viewId)
            return widget;
    }
    return NULL;
}

- (void) addDebugWidget:(NSString*)viewId
{
    WidgetView *widget = [[WidgetView alloc] initWithId:viewId frame:[self bounds]];
    [self addWidget:widget];
    
    if ([viewId compare:@"Weather"] == NSOrderedSame)
    {
        WeatherWidgetViewController *ctrl;
        ctrl = [[WeatherWidgetViewController alloc] init];
        widget.contentView = ctrl.view;
        [controllers addObject:ctrl];
        [ctrl release];
    }
    else if ([viewId compare:@"News"] == NSOrderedSame)
    {
        NewsWidgetViewController *newsCtrl;
        newsCtrl = [[NewsWidgetViewController alloc] init];
        widget.contentView = newsCtrl.view;
        [controllers addObject:newsCtrl];
        [newsCtrl release];
    }
    
    [widget release];
}
    
- (GridLayout *) createLandscapeLayout
{
    GridLayout *layout = [[GridLayout alloc] init];
    [layout setPaddingTop:5];
    [layout setPaddingLeft:5];
    [layout setPaddingRight:5];
    [layout setPaddingBottom:5];
    [layout setHorizontalGap:10];
    [layout setVerticalGap:10];
    
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    
    // first column
    GridColumnLayout *column = [[GridColumnLayout alloc] init];
    [column setPercentWidth:100];
    NSMutableArray *cellList = [[NSMutableArray alloc] init];
    
    GridCellLayout *cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"Weather"];
    [cell setPercentHeight:40];
    [cellList addObject:cell];
    [cell release];
    
    cell = [[GridCellLayout alloc] init];      
    [cell setViewId:@"Mail"];
    [cell setPercentHeight:60];
    [cellList addObject:cell];
    [cell release];
    
    [column setCellList:cellList];
    [cellList release];
    
    [columnList addObject:column];
    [column release];
    
    // second column
    column = [[GridColumnLayout alloc] init];
    [column setPercentWidth:100];        
    cellList = [[NSMutableArray alloc] init];
    
    cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"Notes"];
    [cell setPercentHeight:50];
    [cellList addObject:cell];
    [cell release];
    
    cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"Calendar"];
    [cell setPercentHeight:50];
    [cellList addObject:cell];
    [cell release];
    
    [column setCellList:cellList];
    [cellList release];
    
    [columnList addObject:column];
    [column release];
    
    // third column
    column = [[GridColumnLayout alloc] init];        
    [column setPercentWidth:100];        
    cellList = [[NSMutableArray alloc] init];
    
    cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"News"];
    [cell setPercentHeight:100];
    [cellList addObject:cell];
    [cell release];
    
    [column setCellList:cellList];
    [cellList release];
    
    [columnList addObject:column];
    [column release];
    
    [layout setColumnList:columnList];
    [columnList release];
    
    return layout;
}

- (GridLayout *) createPortraitLayout
{
    GridLayout *layout = [[GridLayout alloc] init];
    [layout setPaddingTop:5];
    [layout setPaddingLeft:5];
    [layout setPaddingRight:5];
    [layout setPaddingBottom:5];
    [layout setHorizontalGap:10];
    [layout setVerticalGap:10];
    
    NSMutableArray *columnList = [[NSMutableArray alloc] init];
    
    // first column
    GridColumnLayout *column = [[GridColumnLayout alloc] init];
    [column setPercentWidth:100];
    NSMutableArray *cellList = [[NSMutableArray alloc] init];
    
    GridCellLayout *cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"Weather"];
    [cell setPercentHeight:40];
    [cellList addObject:cell];
    [cell release];
    
    cell = [[GridCellLayout alloc] init];      
    [cell setViewId:@"Mail"];
    [cell setPercentHeight:30];
    [cellList addObject:cell];
    [cell release];
    
    cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"Notes"];
    [cell setPercentHeight:30];
    [cellList addObject:cell];
    [cell release];
    
    [column setCellList:cellList];
    [cellList release];
    
    [columnList addObject:column];
    [column release];
    
    // second column
    column = [[GridColumnLayout alloc] init];
    [column setPercentWidth:100];        
    cellList = [[NSMutableArray alloc] init];
        
    cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"News"];
    [cell setPercentHeight:60];
    [cellList addObject:cell];
    [cell release];

    cell = [[GridCellLayout alloc] init];
    [cell setViewId:@"Calendar"];
    [cell setPercentHeight:40];
    [cellList addObject:cell];
    [cell release];
    
    [column setCellList:cellList];
    [cellList release];
    
    [columnList addObject:column];
    [column release];
        
    [layout setColumnList:columnList];
    [columnList release];
    
    return [layout autorelease];
}

@end

@implementation DesktopView

@synthesize landscapeLayout;
@synthesize portraitLayout;
@synthesize widgetList=widgets;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setAutoresizesSubviews:FALSE];
        
        // Initialization code
        widgets = [[NSMutableArray alloc] initWithCapacity:10];
        controllers = [[NSMutableArray alloc] init];
        
        [self addDebugWidget:@"Weather"];
        [self addDebugWidget:@"Mail"];
        [self addDebugWidget:@"Notes"];
        [self addDebugWidget:@"News"];
        [self addDebugWidget:@"Calendar"];
        
        // create debug layout
        
        [self setLandscapeLayout:[self createLandscapeLayout]];
        [self setPortraitLayout:[self createPortraitLayout]];
    }
    return self;    
}

- (NSMutableArray *)getWidgets
{
    return widgets;
}

- (GridLayout *)layout
{
    CGRect rc = [self bounds];
    return rc.size.width > rc.size.height ? [self landscapeLayout] : [self portraitLayout];
}

- (void)dealloc
{
    [widgets release];
    [super dealloc];
}

- (void) addWidget:(WidgetView*)widget
{
    [widgets addObject:widget];
    [self addSubview:widget];
    [self setNeedsLayout];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rc = [self bounds];
    //    CGRect rc2 = [self frame];
    //[backgroundImage drawInRect:rc];
    
    // Paint main rectangle of the widget
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rc);
}

- (void) layoutSubviews
{
    if (self.layout == NULL)
        return;
    
    GridLayout *layout = [self layout];
    CGFloat dStartX = [layout paddingLeft];
    CGFloat dStartY = [layout paddingTop];
    
    // calculate width available for the columns
    CGFloat dAvailableWidth = [self bounds].size.width;
    dAvailableWidth -= [[self layout] paddingLeft];
    dAvailableWidth -= [layout paddingTop];
    
    // calculate total number of visible columns and amount of gap between them
    GridColumnLayout *column;
    NSUInteger len = 0;
    CGFloat dTotalPercentWidth = 0;
    for (column in [layout columnList])
    {
        if ([column isIncludedInLayout])
        {
            len++;
            dTotalPercentWidth += [column percentWidth];
        }
    }
    // If total width equals zero then there is nothing we can do
    if (dTotalPercentWidth == 0)
        return;
    if (len > 0)
        dAvailableWidth -= [layout horizontalGap] * (len - 1);
    
    // calculate height available for the columns
    CGFloat dAvailableHeight = [self bounds].size.height;
    dAvailableHeight -= [layout paddingTop];
    dAvailableHeight -= [layout paddingBottom];
    
    // layout columns
    CGFloat dWidth = 0;
    for (column in [layout columnList])
    {
        if (![column isIncludedInLayout])
            continue;
        
        dWidth = [column percentWidth] * dAvailableWidth / dTotalPercentWidth;
        dWidth = round(dWidth);
        
        [self layoutColumn:column x:dStartX y:dStartY width:dWidth height:dAvailableHeight];
        
        dStartX += dWidth + [layout horizontalGap];
    }
}

@end
