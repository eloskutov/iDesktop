//
//  DesktopView.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WidgetView, GridLayout;

@interface DesktopView : UIView
{
    @private
    NSMutableArray *widgets;
    NSMutableArray *controllers;
}

/** Layout of the desktop in landscape orientation. */
@property(retain) GridLayout *landscapeLayout;
/** Layout of the desktop in portrait orientation. */
@property(retain) GridLayout *portraitLayout;
@property(readonly, assign) NSMutableArray *widgetList;

- (void) addWidget:(WidgetView*)widget;
- (GridLayout *)layout;

@end
