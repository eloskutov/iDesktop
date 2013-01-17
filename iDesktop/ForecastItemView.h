//
//  ForecastItemView.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForecastItemView : NSObject

@property (assign) UILabel *dayLabel;
@property (assign) UIImageView *conditionImage;
@property (assign) UILabel *highTempLabel;
@property (assign) UILabel *lowTempLabel;

@end
