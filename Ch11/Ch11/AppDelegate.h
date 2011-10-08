//
//  AppDelegate.h
//  Ch11
//
//  Created by Kyle Roche on 10/4/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate> {

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;
@end
