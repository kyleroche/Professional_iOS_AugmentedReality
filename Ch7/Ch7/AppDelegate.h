//
//  AppDelegate.h
//  Ch7
//
//  Created by Kyle Roche on 9/5/11.
//  Copyright Isidorey 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
    UIView  *cameraView;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
