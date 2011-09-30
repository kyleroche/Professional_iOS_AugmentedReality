//
//  iOS_AR_Ch4_SensorsAppDelegate.h
//  iOS_AR_Ch4_Sensors
//
//  Created by Kyle Roche on 7/5/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iOS_AR_Ch4_SensorsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
