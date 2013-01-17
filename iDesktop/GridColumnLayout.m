//
//  GridColumnLayout.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridColumnLayout.h"
#import "GridCellLayout.h"

@implementation GridColumnLayout

@synthesize percentWidth;
@synthesize cellList;

- (void)setCellList:(NSMutableArray *)newCellList
{
    if (cellList != newCellList)
    {
        [cellList release];
        cellList = [newCellList mutableCopy];
        for (GridCellLayout *cell in cellList)
            [cell setColumn:self];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [cellList release];
    
    [super dealloc];
}

- (bool)isIncludedInLayout
{
    GridCellLayout *cell;
    for (cell in cellList)
    {
        if ([cell isIncludedInLayout])
            return true;
    }
    return false;
}

- (void)removeCell:(GridCellLayout*)cell
{
    [cellList removeObject:cell];
    if ([cell column] == self)         
        [cell setColumn:NULL];
}

- (void)addCell:(GridCellLayout*)cell atIndex:(NSUInteger)index
{
    if ([cell column] != self)
    {
        [cellList insertObject:cell atIndex:index];
    }
    else
    {
        NSUInteger indexOld = [cellList indexOfObject:cell];
        [cellList exchangeObjectAtIndex:indexOld withObjectAtIndex:index];
    }
    [cell setColumn:self];
}


@end
