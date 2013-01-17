//
//  GridCellLayout.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GridColumnLayout;

/** Definition of a single cell layout inside a grid. */
@interface GridCellLayout : NSObject

/** Height of the cell in percents of total height. */
@property(nonatomic) CGFloat percentHeight;
@property(nonatomic) CGFloat fixedHeight;
/** true if cell is included in layout, false if it is disabled. */
@property(nonatomic) bool isIncludedInLayout;
/** true if height of the cell should be fixed instead of being calculated dynamically 
    based on percentHeight. The height is defined by the height of cell's view.
 */
@property(nonatomic) bool isFixedHeight;
/** Identifier of the view assigned to the cell. */
@property(copy) NSString *viewId;
/** Column the cell belongs to. */
@property(assign) GridColumnLayout *column;
          

@end
