//
//  WidgetView.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridCellLayout;

@interface WidgetView : UIView
{
    UIImage *backgroundImage;
    UIView *_contentView;
    
    bool isPressed;
    bool isTouchMoved;
    bool _isDragging;
    CGPoint pointDragStart;
    CGPoint pointCenter;
    CGRect originalFrame;
}

@property(copy) NSString *viewId;
@property(copy) UIView *contentView;
@property(retain) GridCellLayout *cell;
@property bool isExpanded;
@property bool isDragging;

- (bool) isExpanded;
- (void) setIsExpanded:(bool)isExpanded;

- (bool) isDragging;
- (void) setIsDragging:(bool)bIsDragging;
- (id) initWithId:(NSString*)viewId frame:(CGRect)frame;

@end
