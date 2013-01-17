//
//  TabControlItem.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollableTabControl;

@interface TabControlItem : UIControl
{
    CGColorRef selectedColor;
    CGColorRef highlightColor;
    CGColorRef normalColor;
    UIColor *selectedTextColor;
    UIColor *normalTextColor;
    UIColor *highlightedTextColor;
    UILabel *label;
}

@property(copy) NSString* text;
@property(nonatomic) UIEdgeInsets titleEdgeInsets;
@property(assign) ScrollableTabControl* tabControl;

@end
