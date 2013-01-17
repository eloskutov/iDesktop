//
//  GridLayout.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridLayout.h"

@implementation GridLayout

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    self.paddingLeft = 0;
    self.paddingTop = 0;
    self.paddingRight = 0;
    self.paddingBottom = 0;
    
    self.horizontalGap = 5;
    self.verticalGap = 5;
    
    return self;
}

- (void)dealloc
{
    [columnList release];
    [super dealloc];
}

@synthesize paddingLeft;
@synthesize paddingTop;
@synthesize paddingRight;
@synthesize paddingBottom;
@synthesize horizontalGap;
@synthesize verticalGap;

@synthesize columnList;

- (void)setColumnList:(NSMutableArray *)newColumnList
{
    if (columnList != newColumnList)
    {
        [columnList release];
        columnList = [newColumnList mutableCopy];
    }
}

@end
