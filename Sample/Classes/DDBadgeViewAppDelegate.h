//
//  DDBadgeViewAppDelegate.h
//  DDBadgeView
//
//  Created by digdog on 5/16/10.
//  Copyright Ching-Lan 'digdog' HUANG and digdog software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDBadgeViewAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

