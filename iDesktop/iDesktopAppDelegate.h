//
//  iDesktopAppDelegate.h
//  iDesktop
//
//  Created by Evgeny Loskutov on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iDesktopViewController;

@interface iDesktopAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet iDesktopViewController *viewController;

@end
