//
//  GridCellLayout.m
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridCellLayout.h"

@implementation GridCellLayout

@synthesize percentHeight;
@synthesize fixedHeight;
@synthesize isIncludedInLayout;
@synthesize isFixedHeight;
@synthesize viewId;
@synthesize column;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self setIsFixedHeight:false];
        [self setIsIncludedInLayout:true];
        [self setFixedHeight:0];
    }
    
    return self;
}

- (void) dealloc
{
    [viewId release];
    
    [super dealloc];
}

@end
