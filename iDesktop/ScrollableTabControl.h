//
//  ScrollableTabControl.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabControlItem;

@interface ScrollableTabControl : UIView
{
    NSArray* tabItems;
    UIScrollView *scrollView;
    TabControlItem *selectedItem;
}

@property(nonatomic, copy) NSArray* items;
@property(nonatomic) UIEdgeInsets edgeInsets;
@property(assign) TabControlItem* selectedItem;

@end
