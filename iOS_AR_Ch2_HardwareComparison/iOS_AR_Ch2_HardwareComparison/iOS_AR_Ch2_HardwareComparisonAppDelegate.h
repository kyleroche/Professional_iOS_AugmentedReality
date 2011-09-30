//
//  iOS_AR_Ch2_HardwareComparisonAppDelegate.h
//  iOS_AR_Ch2_HardwareComparison
//
//  Created by Kyle Roche on 6/13/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iOS_AR_Ch2_HardwareComparisonAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
