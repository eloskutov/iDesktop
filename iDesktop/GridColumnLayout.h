//
//  GridColumnLayout.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridCellLayout;

/** Defines layout of a single column in grid layout. */
@interface GridColumnLayout : NSObject
{
    NSMutableArray *cellList;
}

/** List of cells to be displayed in the column. */
@property(nonatomic, copy) NSMutableArray *cellList;
/** Percent width of the column. */
@property(nonatomic) CGFloat percentWidth;

/** Checks if column is included in layout (at least one cell is included in layout). */
- (bool)isIncludedInLayout;
- (void)removeCell:(GridCellLayout*)cell;
- (void)addCell:(GridCellLayout*)cell atIndex:(NSUInteger)index;

@end
