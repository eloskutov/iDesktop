//
//  GridLayout.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Defines grid layout.
 The layout places ui elements in columns. And each column places elements in rows.
 */
@interface GridLayout : NSObject
{
    NSMutableArray *columnList;
}

@property(nonatomic, copy) NSMutableArray *columnList;

@property(nonatomic) CGFloat paddingLeft;
@property(nonatomic) CGFloat paddingTop;
@property(nonatomic) CGFloat paddingRight;
@property(nonatomic) CGFloat paddingBottom;
@property(nonatomic) CGFloat horizontalGap;
@property(nonatomic) CGFloat verticalGap;

@end
